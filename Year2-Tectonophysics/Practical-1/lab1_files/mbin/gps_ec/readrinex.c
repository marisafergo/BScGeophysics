#include <stdio.h>
#include <string.h>
#include <math.h>
#include "mex.h"

/*
readrinex  Reads rinex file and outputs:
           - observables (as a structure)
           - date and time of obs (as a matrix)
           - PRN numbers (as a vector)
           - a priori coordinates (from rinex header)

           This version reads GPS and GLONASS.
           WARNING: GPS PRNs are assumed to be < 50
                    GLONASS PRNs are PRN+50 (e.g. R3 is named 53)

If Matlab crashes with segmentation violation when reading rinex
file try running the rinex file through teqc first.

Usage: [Observables,epochs,sv,apcoords]=readrinex(filename)

Sun Nov  1 19:08:07 EST 2009
ecalais@purdue.edu
*/

FILE *fIn;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
	char *FileName;
   const char **Observables;
	char GetString[82], SatType[99];
	int i,j,k,ns, LineFlag,FileNameLength,NumObs,NumSats,NumG,NumR,NumEpochs;
	int SatColumn[99]={0}, ColumnIndex[99]={0}, CurrentSats[99]={0}, SatCount[99]={0};
	double XYZ[3], O, *pSatellites;
	double **pObs, *pEpoch;
	mxArray **mxObs;

	if (nrhs!=1)
		mexErrMsgTxt("Usage: [Observables,epochs,sv,apcoords]=readrinex(filename).");

	if (mxIsChar(prhs[0])==0)
		mexErrMsgTxt("First argument must be a rinex file name.");

	FileNameLength = (mxGetM(prhs[0])*mxGetN(prhs[0]))+1;
	FileName =(char *)mxCalloc(FileNameLength,sizeof(char));

	mxGetString(prhs[0],FileName,FileNameLength);

	/* Try to open rinex file. */

   fIn = fopen(FileName, "r");
   if (fIn==NULL)
      mexErrMsgTxt("Could not open file.");

	/* Check for valid RINEX file.*/

   fgets(GetString, 82, fIn);
   printf("Reading %s, RINEX version %c\n",FileName,GetString[5]);
   if(strstr(GetString,"RINEX VERSION / TYPE") == 0)
   {
     printf("\n%s",GetString);
     mexErrMsgTxt("Invalid RINEX header.");
   }

	/* Determine number/type of observables. */

		while (fgets(GetString, 82, fIn))
		{
			if(GetString[62]==47) /* Look for the '/' in '# / TYPES OF OBSERV' */
			{
				sscanf(GetString,"%d",&NumObs);
				/*Observables = (char **)mxCalloc(NumObs,sizeof(char *));*/
				Observables = mxCalloc(NumObs,sizeof(char *));
			 	if(NumObs>5)
					LineFlag=2;
				else
					LineFlag=1;

				for(i=0;i<NumObs;i++)
				{
					Observables[i] = (char *)mxCalloc(3,sizeof(char));
					sscanf(&GetString[6+i*6],"%2s",Observables[i]);
				}
				printf("Found %d observables\n",NumObs);
			}
			if(GetString[62]==80) /* Look for the 'P' in 'APPROX POSITION XYZ' */
			{
				XYZ[0]=atof(&GetString[0]);
				XYZ[1]=atof(&GetString[15]);
				XYZ[2]=atof(&GetString[29]);
				printf("Approx. position (XYZ, m)= %.4f %.4f %.4f\n",XYZ[0],XYZ[1],XYZ[2]);
			}

			if(GetString[62]==68) /* Look for the 1st 'D' in 'END OF HEADER' */
				break;
		}
	
	/* Count number of epochs, see how often each satellite appears. */

		NumEpochs=0;
		while(fgets(GetString, 82, fIn))
		{
			ns=atoi(&GetString[29]);
         if(GetString[2]==32)
         /* Fix spliced files problem */
         {
           for (i=0;i<ns;i++)
           fgets(GetString, 82, fIn);
         }
         else
         {
	        NumEpochs++;
	        for(i=0;i<ns;i++)
           {
             if(GetString[32+i*3] == 82) /* GLONASS */
               { SatCount[atoi(&GetString[33+i*3])+50]++; }
             else
               { SatCount[atoi(&GetString[33+i*3])]++; }
             if(i==11)
                break;
           }

           if (ns>12)
           {
             fgets(GetString, 82, fIn);
			    for(j=0;j<ns-i-1;j++)
             {
               if(GetString[32+j*3] == 82) /* GLONASS */
                  { SatCount[atoi(&GetString[33+j*3])+50]++; }
               else
                  { SatCount[atoi(&GetString[33+j*3])]++; }
             }
           }

           for (i=0;i<LineFlag*ns;i++)
             fgets(GetString, 82, fIn);
         }
		}
		printf("Found %d epochs\n",NumEpochs);

	/* Determine number of satellites, set up satellite column indices. */
		
		NumSats=0;
      NumG = 0;
      NumR = 0;
		for (i=0;i<99;i++)
			if (SatCount[i]>0)
			{
				SatColumn[i]=NumSats;
				SatCount[NumSats]=i;
				NumSats++;
            if (i<50) NumG++;
            if (i>=50) NumR++;
			}
			printf("Found %d satellites: %d GPS, %d GLONASS\n",NumSats, NumG, NumR);

	
	/* Allocate memory to hold outputs */
		
		mxObs = (mxArray **)mxCalloc(NumObs,sizeof(mxArray *));
		pObs = (double **)mxCalloc(NumObs,sizeof(double *));
		plhs[0]=mxCreateStructMatrix(1,1,NumObs,Observables);
		plhs[1]=mxCreateDoubleMatrix(NumEpochs,6,mxREAL);
		plhs[2]=mxCreateDoubleMatrix(NumSats,1,mxREAL);
		plhs[3]=mxCreateDoubleMatrix(3,1,mxREAL);

		pSatellites=mxGetPr(plhs[2]);
		for (i=0;i<NumSats;i++)
			pSatellites[i]=SatCount[i];

		memcpy(mxGetPr(plhs[3]),XYZ,3*sizeof(double));
		pEpoch = mxGetPr(plhs[1]);

		for(i=0;i<NumObs;i++)
		{
			mxObs[i] = mxCreateDoubleMatrix(NumEpochs,NumSats,mxREAL);
			pObs[i] = mxGetPr(mxObs[i]);
			memset(pObs[i],255,NumEpochs*NumSats*sizeof(double));
		} 

	/* Get observables. */

		k=0;
		fseek(fIn,0,SEEK_SET);


      /* Skip header */
		while (fgets(GetString, 82, fIn))
			if(GetString[62]==68) /* Look for the 1st 'D' in 'END OF HEADER' */ 
				break;

      while (fgets(GetString, 82, fIn))
      {
        ns=atoi(&GetString[29]);

        /* Fix spliced files problem */
        if(GetString[2]==32)
        {
          for(i=0;i<ns;i++)
          fgets(GetString, 82, fIn);
        }
        else
        {
          /* Read date and time */
          pEpoch[k]=atoi(&GetString[0]);
          pEpoch[k+NumEpochs]=atoi(&GetString[4]);
          pEpoch[k+2*NumEpochs]=atoi(&GetString[7]);
          pEpoch[k+3*NumEpochs]=atoi(&GetString[10]);
          pEpoch[k+4*NumEpochs]=atoi(&GetString[13]);
          pEpoch[k+5*NumEpochs]=atof(&GetString[16]);

          /* Read PRN numbers */
          for(i=0;i<ns;i++)
          {
            if(GetString[32+i*3] == 82) /* GLONASS */
              { ColumnIndex[i]=SatColumn[atoi(&GetString[33+i*3])+50]; }
            else
              { ColumnIndex[i]=SatColumn[atoi(&GetString[33+i*3])]; }
            if(i==11)
               break;
          }

          /* if more than 12 PRN's, read PRN on second line */
          if (ns>12)
          {
             fgets(GetString, 82, fIn);
             for(j=0;j<ns-12;j++)
             {
                i++;
                if(GetString[32+j*3] == 82) /* GLONASS */
                   { ColumnIndex[i]=SatColumn[atoi(&GetString[33+j*3])+50]; }
                else
                  { ColumnIndex[i]=SatColumn[atoi(&GetString[33+j*3])]; }
             }
           }

           /* read observables */
           for (i=0;i<ns;i++)
           {
             memset(GetString,0,82);
             fgets(GetString, 82, fIn);
             for (j=0;j<NumObs;j++)
             { 
               GetString[14+j*16]=0;
               O=atof(&GetString[j*16]);
               if(O)
               pObs[j][k+ColumnIndex[i]*NumEpochs]=O;
             }

             /* keep reading observables if two lines */
             if (LineFlag == 2)
             {
               memset(GetString,0,82);
               fgets(GetString, 82, fIn);
               for (j=5;j<NumObs;j++)
               { 
                 GetString[14+(j-5)*16]=0;
                 O=atof(&GetString[(j-5)*16]);
                 if(O)
                   pObs[j][k+ColumnIndex[i]*NumEpochs]=O;
					}
             }
           }
           k++;
			}
		}

	fclose(fIn);

	/* Output observables to structure. */
	
   for(i=0;i<NumObs;i++)
     mxSetFieldByNumber(plhs[0],0,i,mxObs[i]);

}					 
