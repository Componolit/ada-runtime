int gnat_exit_status = 0;

void __gnat_set_exit_status (int value)
{
   gnat_exit_status = value;
};
