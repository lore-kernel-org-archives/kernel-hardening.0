Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jul 2016 09:29:14 +0800
From: kbuild test robot <lkp@intel.com>
Message-ID: <201607270916.E2ItSW4g%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20160726224234.c680b28a327365604664cb2b@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3 6/7] Mark a few functions with the printf attribute
To: Emese Revfy <re.emese@gmail.com>
Cc: kbuild-all@01.org, kernel-hardening@lists.openwall.com, pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de
List-ID: <kernel-hardening.lists.openwall.com>


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

[auto build test WARNING on next-20160726]
[cannot apply to stable/master linus/master linux/master v4.7-rc7 v4.7-rc6 v4.7-rc5 v4.7]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Emese-Revfy/Introduce-the-initify-gcc-plugin/20160727-084514
config: x86_64-randconfig-s3-07270832 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-9) 6.1.1 20160705
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   drivers/acpi/acpica/utdebug.c: In function 'acpi_debug_print':
>> drivers/acpi/acpica/utdebug.c:192:26: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
     acpi_os_printf("%9s-%04ld ", module_name, line_number);
                             ^
--
   drivers/acpi/acpica/dbhistry.c: In function 'acpi_db_display_history':
>> drivers/acpi/acpica/dbhistry.c:158:23: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
       acpi_os_printf("%3ld %s\n",
                          ^
--
   drivers/acpi/acpica/dbinput.c: In function 'acpi_db_get_line':
>> drivers/acpi/acpica/dbinput.c:609:56: warning: format '%u' expects argument of type 'unsigned int', but argument 2 has type 'long unsigned int' [-Wformat=]
          ("Buffer overflow while parsing input line (max %u characters)\n",
                                                           ^
   drivers/acpi/acpica/dbinput.c: In function 'acpi_db_command_dispatch':
>> drivers/acpi/acpica/dbinput.c:865:58: warning: format '%lX' expects argument of type 'long unsigned int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Current debug level for file output is:    %8.8lX\n",
                                                             ^
   drivers/acpi/acpica/dbinput.c:868:58: warning: format '%lX' expects argument of type 'long unsigned int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Current debug level for console output is: %8.8lX\n",
                                                             ^
   drivers/acpi/acpica/dbinput.c:875:50: warning: format '%lX' expects argument of type 'long unsigned int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Debug Level for console output was %8.8lX, now %8.8lX\n",
                                                     ^
   drivers/acpi/acpica/dbinput.c:875:62: warning: format '%lX' expects argument of type 'long unsigned int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Debug Level for console output was %8.8lX, now %8.8lX\n",
                                                                 ^
   drivers/acpi/acpica/dbinput.c:882:47: warning: format '%lX' expects argument of type 'long unsigned int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Debug Level for file output was %8.8lX, now %8.8lX\n",
                                                  ^
   drivers/acpi/acpica/dbinput.c:882:59: warning: format '%lX' expects argument of type 'long unsigned int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
           ("Debug Level for file output was %8.8lX, now %8.8lX\n",
                                                              ^
--
   drivers/acpi/acpica/dbstats.c: In function 'acpi_db_display_statistics':
>> drivers/acpi/acpica/dbstats.c:380:33: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
       acpi_os_printf("%16.16s % 10ld% 10ld\n",
                                    ^
   drivers/acpi/acpica/dbstats.c:380:39: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Wformat=]
       acpi_os_printf("%16.16s % 10ld% 10ld\n",
                                          ^
   drivers/acpi/acpica/dbstats.c:386:32: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
      acpi_os_printf("%16.16s % 10ld% 10ld\n", "Misc/Unknown",
                                   ^
   drivers/acpi/acpica/dbstats.c:386:38: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'int' [-Wformat=]
      acpi_os_printf("%16.16s % 10ld% 10ld\n", "Misc/Unknown",
                                         ^
>> drivers/acpi/acpica/dbstats.c:390:32: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
      acpi_os_printf("%16.16s % 10ld% 10ld\n", "TOTALS:",
                                   ^
   drivers/acpi/acpica/dbstats.c:390:38: warning: format '%ld' expects argument of type 'long int', but argument 4 has type 'u32 {aka unsigned int}' [-Wformat=]
      acpi_os_printf("%16.16s % 10ld% 10ld\n", "TOTALS:",
                                         ^
   drivers/acpi/acpica/dbstats.c:418:54: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
      acpi_os_printf("Calls to AcpiPsFind:.. ........% 7ld\n",
                                                         ^
   drivers/acpi/acpica/dbstats.c:420:55: warning: format '%ld' expects argument of type 'long int', but argument 2 has type 'u32 {aka unsigned int}' [-Wformat=]
      acpi_os_printf("Calls to AcpiNsLookup:..........% 7ld\n",
                                                          ^
   drivers/acpi/acpica/dbstats.c:427:35: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'u32 {aka unsigned int}' [-Wformat=]
       acpi_os_printf("%-28s:     % 7ld\n",
                                      ^
>> drivers/acpi/acpica/dbstats.c:437:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Common         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:439:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Number         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:441:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("String         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:443:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Buffer         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:445:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Package        %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:447:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("BufferField    %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:449:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Device         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:451:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Event          %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:453:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Method         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:455:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Mutex          %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:457:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Region         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:459:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("PowerResource  %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:461:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Processor      %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:463:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("ThermalZone    %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:465:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("RegionField    %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:467:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("BankField      %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:469:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("IndexField     %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:471:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Reference      %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:473:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Notify         %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:475:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("AddressSpace   %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:477:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Extra          %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:479:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Data           %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:484:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("ParseObject    %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:486:38: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("ParseObjectNamed %3d\n",
                                         ^
   drivers/acpi/acpica/dbstats.c:488:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("ParseObjectAsl %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:490:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("OperandObject  %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:492:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("NamespaceNode  %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:494:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("AcpiObject     %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:499:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Generic State  %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:501:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Common State   %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:503:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Control State  %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:505:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Update State   %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:507:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Scope State    %3d\n",
                                       ^
   drivers/acpi/acpica/dbstats.c:509:36: warning: format '%d' expects argument of type 'int', but argument 2 has type 'long unsigned int' [-Wformat=]
      acpi_os_printf("Parse Scope    %3d\n",

vim +192 drivers/acpi/acpica/utdebug.c

^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  176  	thread_id = acpi_os_get_thread_id();
0dfaaa3d drivers/acpi/acpica/utdebug.c    Bob Moore      2016-03-24  177  	if (thread_id != acpi_gbl_previous_thread_id) {
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  178  		if (ACPI_LV_THREADS & acpi_dbg_level) {
4be44fcd drivers/acpi/utilities/utdebug.c Len Brown      2005-08-05  179  			acpi_os_printf
28eb3fcf drivers/acpi/acpica/utdebug.c    Lin Ming       2010-09-15  180  			    ("\n**** Context Switch from TID %u to TID %u ****\n\n",
0dfaaa3d drivers/acpi/acpica/utdebug.c    Bob Moore      2016-03-24  181  			     (u32)acpi_gbl_previous_thread_id, (u32)thread_id);
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  182  		}
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  183  
0dfaaa3d drivers/acpi/acpica/utdebug.c    Bob Moore      2016-03-24  184  		acpi_gbl_previous_thread_id = thread_id;
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  185  		acpi_gbl_nesting_level = 0;
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  186  	}
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  187  
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  188  	/*
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  189  	 * Display the module name, current line number, thread ID (if requested),
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  190  	 * current procedure nesting level, and the current procedure name
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  191  	 */
2856846e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-09-23 @192  	acpi_os_printf("%9s-%04ld ", module_name, line_number);
^1da177e drivers/acpi/utilities/utdebug.c Linus Torvalds 2005-04-16  193  
5076f005 drivers/acpi/acpica/utdebug.c    Bob Moore      2014-01-08  194  #ifdef ACPI_APPLICATION
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  195  	/*
5076f005 drivers/acpi/acpica/utdebug.c    Bob Moore      2014-01-08  196  	 * For acpi_exec/iASL only, emit the thread ID and nesting level.
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  197  	 * Note: nesting level is really only useful during a single-thread
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  198  	 * execution. Otherwise, multiple threads will keep resetting the
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  199  	 * level.
bf9b448e drivers/acpi/acpica/utdebug.c    Bob Moore      2013-11-21  200  	 */

:::::: The code at line 192 was first introduced by commit
:::::: 2856846e3a7bee02ce6b498c760376061e41aaed ACPICA: Debug output: small formatting update, no functional change.

:::::: TO: Bob Moore <robert.moore@intel.com>
:::::: CC: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--IJpNTDwzlM2Ie8A6
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
dwEA

--IJpNTDwzlM2Ie8A6--
