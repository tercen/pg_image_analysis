/*
 * MATLAB Compiler: 4.2 (R14SP2)
 * Date: Mon Jun 13 10:41:29 2005
 * Arguments: "-B" "macro_default" "-m" "-W" "main" "-T" "link:exe" "-d"
 * "C:\PamSoft\DataAnalysis\CurveFitHT\bin" "CurveFitHT" "CurveFitHT_pragma" 
 */

#include <stdio.h>
#include "mclmcr.h"
#ifdef __cplusplus
extern "C" {
#endif
extern const unsigned char __MCC_CurveFitHT_public_data[];
extern const char *__MCC_CurveFitHT_name_data;
extern const char *__MCC_CurveFitHT_root_data;
extern const unsigned char __MCC_CurveFitHT_session_data[];
extern const char *__MCC_CurveFitHT_matlabpath_data[];
extern const int __MCC_CurveFitHT_matlabpath_data_count;
extern const char *__MCC_CurveFitHT_classpath_data[];
extern const int __MCC_CurveFitHT_classpath_data_count;
extern const char *__MCC_CurveFitHT_lib_path_data[];
extern const int __MCC_CurveFitHT_lib_path_data_count;
extern const char *__MCC_CurveFitHT_mcr_runtime_options[];
extern const int __MCC_CurveFitHT_mcr_runtime_option_count;
extern const char *__MCC_CurveFitHT_mcr_application_options[];
extern const int __MCC_CurveFitHT_mcr_application_option_count;
#ifdef __cplusplus
}
#endif

static HMCRINSTANCE _mcr_inst = NULL;


static int mclDefaultPrintHandler(const char *s)
{
    return fwrite(s, sizeof(char), strlen(s), stdout);
}

static int mclDefaultErrorHandler(const char *s)
{
    int written = 0, len = 0;
    len = strlen(s);
    written = fwrite(s, sizeof(char), len, stderr);
    if (len > 0 && s[ len-1 ] != '\n')
        written += fwrite("\n", sizeof(char), 1, stderr);
    return written;
}


/* This symbol is defined in shared libraries. Define it here
 * (to nothing) in case this isn't a shared library. 
 */
#ifndef LIB_CurveFitHT_C_API 
#define LIB_CurveFitHT_C_API /* No special import/export declaration */
#endif

LIB_CurveFitHT_C_API 
bool CurveFitHTInitializeWithHandlers(
    mclOutputHandlerFcn error_handler,
    mclOutputHandlerFcn print_handler
)
{
    if (_mcr_inst != NULL)
        return true;
    if (!mclmcrInitialize())
        return false;
    if (!mclInitializeComponentInstance(&_mcr_inst,
                                        __MCC_CurveFitHT_public_data,
                                        __MCC_CurveFitHT_name_data,
                                        __MCC_CurveFitHT_root_data,
                                        __MCC_CurveFitHT_session_data,
                                        __MCC_CurveFitHT_matlabpath_data,
                                        __MCC_CurveFitHT_matlabpath_data_count,
                                        __MCC_CurveFitHT_classpath_data,
                                        __MCC_CurveFitHT_classpath_data_count,
                                        __MCC_CurveFitHT_lib_path_data,
                                        __MCC_CurveFitHT_lib_path_data_count,
                                        __MCC_CurveFitHT_mcr_runtime_options,
                                        __MCC_CurveFitHT_mcr_runtime_option_count,
                                        true, NoObjectType, ExeTarget, NULL,
                                        error_handler, print_handler))
        return false;
    return true;
}

LIB_CurveFitHT_C_API 
bool CurveFitHTInitialize(void)
{
    return CurveFitHTInitializeWithHandlers(mclDefaultErrorHandler,
                                            mclDefaultPrintHandler);
}

LIB_CurveFitHT_C_API 
void CurveFitHTTerminate(void)
{
    if (_mcr_inst != NULL)
        mclTerminateInstance(&_mcr_inst);
}

int main(int argc, const char **argv)
{
    int _retval;
    if (!mclInitializeApplication(__MCC_CurveFitHT_mcr_application_options,
                                  __MCC_CurveFitHT_mcr_application_option_count))
        return 0;
    
    if (!CurveFitHTInitialize())
        return -1;
    _retval = mclMain(_mcr_inst, argc, argv, "CurveFitHT", 1);
    if (_retval == 0 /* no error */) mclWaitForFiguresToDie(NULL);
    CurveFitHTTerminate();
    mclTerminateApplication();
    return _retval;
}
