/* this symbol is required/expected by the binder */
int gnat_exit_status = 0;

/* this symbol is required/expected by the runtime */
int __ada_runtime_exit_status = 0;

void __gnat_set_exit_status (int value)
{
   gnat_exit_status = value;
   __ada_runtime_exit_status = value;
};
