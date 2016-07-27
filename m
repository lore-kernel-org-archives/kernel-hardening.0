Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 27 Jul 2016 17:34:29 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160727173429.35abb2002ff2f64f26558924@gmail.com>
In-Reply-To: <20160726224234.c680b28a327365604664cb2b@gmail.com>
References: <20160726223541.513ce76f6de65389da6a6abe@gmail.com>
	<20160726224234.c680b28a327365604664cb2b@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 6/7] Mark a few functions with the printf attribute
To: kernel-hardening@lists.openwall.com
Cc: pageexec@freemail.hu, spender@grsecurity.net, mmarek@suse.com, keescook@chromium.org, linux-kernel@vger.kernel.org, yamada.masahiro@socionext.com, linux-kbuild@vger.kernel.org, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, arnd@arndb.de, sam@ravnborg.org, isdn@linux-pingi.de, robert.moore@intel.com, lv.zheng@intel.com
List-ID: <kernel-hardening.lists.openwall.com>

Fixed format strings warnings exposed by the printf attribute.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 drivers/acpi/acpica/dbhistry.c     |  2 +-
 drivers/acpi/acpica/dbinput.c      | 10 ++---
 drivers/acpi/acpica/dbstats.c      | 88 +++++++++++++++++++-------------------
 drivers/acpi/acpica/utdebug.c      |  2 +-
 drivers/scsi/esas2r/esas2r_init.c  |  2 +-
 drivers/scsi/esas2r/esas2r_ioctl.c |  2 +-
 drivers/scsi/esas2r/esas2r_main.c  |  4 +-
 7 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/acpi/acpica/dbhistry.c b/drivers/acpi/acpica/dbhistry.c
index 46bd65d..ec9da48 100644
--- a/drivers/acpi/acpica/dbhistry.c
+++ b/drivers/acpi/acpica/dbhistry.c
@@ -155,7 +155,7 @@ void acpi_db_display_history(void)
 
 	for (i = 0; i < acpi_gbl_num_history; i++) {
 		if (acpi_gbl_history_buffer[history_index].command) {
-			acpi_os_printf("%3ld %s\n",
+			acpi_os_printf("%3u %s\n",
 				       acpi_gbl_history_buffer[history_index].
 				       cmd_num,
 				       acpi_gbl_history_buffer[history_index].
diff --git a/drivers/acpi/acpica/dbinput.c b/drivers/acpi/acpica/dbinput.c
index 7cd5d2e..a837ce6 100644
--- a/drivers/acpi/acpica/dbinput.c
+++ b/drivers/acpi/acpica/dbinput.c
@@ -606,7 +606,7 @@ static u32 acpi_db_get_line(char *input_buffer)
 	    (acpi_gbl_db_parsed_buf, sizeof(acpi_gbl_db_parsed_buf),
 	     input_buffer)) {
 		acpi_os_printf
-		    ("Buffer overflow while parsing input line (max %u characters)\n",
+		    ("Buffer overflow while parsing input line (max %lu characters)\n",
 		     sizeof(acpi_gbl_db_parsed_buf));
 		return (0);
 	}
@@ -862,24 +862,24 @@ acpi_db_command_dispatch(char *input_buffer,
 
 		if (param_count == 0) {
 			acpi_os_printf
-			    ("Current debug level for file output is:    %8.8lX\n",
+			    ("Current debug level for file output is:    %8.8X\n",
 			     acpi_gbl_db_debug_level);
 			acpi_os_printf
-			    ("Current debug level for console output is: %8.8lX\n",
+			    ("Current debug level for console output is: %8.8X\n",
 			     acpi_gbl_db_console_debug_level);
 		} else if (param_count == 2) {
 			temp = acpi_gbl_db_console_debug_level;
 			acpi_gbl_db_console_debug_level =
 			    strtoul(acpi_gbl_db_args[1], NULL, 16);
 			acpi_os_printf
-			    ("Debug Level for console output was %8.8lX, now %8.8lX\n",
+			    ("Debug Level for console output was %8.8X, now %8.8X\n",
 			     temp, acpi_gbl_db_console_debug_level);
 		} else {
 			temp = acpi_gbl_db_debug_level;
 			acpi_gbl_db_debug_level =
 			    strtoul(acpi_gbl_db_args[1], NULL, 16);
 			acpi_os_printf
-			    ("Debug Level for file output was %8.8lX, now %8.8lX\n",
+			    ("Debug Level for file output was %8.8X, now %8.8X\n",
 			     temp, acpi_gbl_db_debug_level);
 		}
 		break;
diff --git a/drivers/acpi/acpica/dbstats.c b/drivers/acpi/acpica/dbstats.c
index a414e1f..de70230 100644
--- a/drivers/acpi/acpica/dbstats.c
+++ b/drivers/acpi/acpica/dbstats.c
@@ -377,17 +377,17 @@ acpi_status acpi_db_display_statistics(char *type_arg)
 			       "ACPI_TYPE", "NODES", "OBJECTS");
 
 		for (i = 0; i < ACPI_TYPE_NS_NODE_MAX; i++) {
-			acpi_os_printf("%16.16s % 10ld% 10ld\n",
+			acpi_os_printf("%16.16s % 10d% 10d\n",
 				       acpi_ut_get_type_name(i),
 				       acpi_gbl_node_type_count[i],
 				       acpi_gbl_obj_type_count[i]);
 		}
 
-		acpi_os_printf("%16.16s % 10ld% 10ld\n", "Misc/Unknown",
+		acpi_os_printf("%16.16s % 10d% 10d\n", "Misc/Unknown",
 			       acpi_gbl_node_type_count_misc,
 			       acpi_gbl_obj_type_count_misc);
 
-		acpi_os_printf("%16.16s % 10ld% 10ld\n", "TOTALS:",
+		acpi_os_printf("%16.16s % 10d% 10d\n", "TOTALS:",
 			       acpi_gbl_num_nodes, acpi_gbl_num_objects);
 		break;
 
@@ -415,16 +415,16 @@ acpi_status acpi_db_display_statistics(char *type_arg)
 	case CMD_STAT_MISC:
 
 		acpi_os_printf("\nMiscellaneous Statistics:\n\n");
-		acpi_os_printf("Calls to AcpiPsFind:.. ........% 7ld\n",
+		acpi_os_printf("Calls to AcpiPsFind:.. ........% 7u\n",
 			       acpi_gbl_ps_find_count);
-		acpi_os_printf("Calls to AcpiNsLookup:..........% 7ld\n",
+		acpi_os_printf("Calls to AcpiNsLookup:..........% 7u\n",
 			       acpi_gbl_ns_lookup_count);
 
 		acpi_os_printf("\n");
 
 		acpi_os_printf("Mutex usage:\n\n");
 		for (i = 0; i < ACPI_NUM_MUTEX; i++) {
-			acpi_os_printf("%-28s:     % 7ld\n",
+			acpi_os_printf("%-28s:     % 7u\n",
 				       acpi_ut_get_mutex_name(i),
 				       acpi_gbl_mutex_info[i].use_count);
 		}
@@ -434,87 +434,87 @@ acpi_status acpi_db_display_statistics(char *type_arg)
 
 		acpi_os_printf("\nInternal object sizes:\n\n");
 
-		acpi_os_printf("Common         %3d\n",
+		acpi_os_printf("Common         %3lu\n",
 			       sizeof(struct acpi_object_common));
-		acpi_os_printf("Number         %3d\n",
+		acpi_os_printf("Number         %3lu\n",
 			       sizeof(struct acpi_object_integer));
-		acpi_os_printf("String         %3d\n",
+		acpi_os_printf("String         %3lu\n",
 			       sizeof(struct acpi_object_string));
-		acpi_os_printf("Buffer         %3d\n",
+		acpi_os_printf("Buffer         %3lu\n",
 			       sizeof(struct acpi_object_buffer));
-		acpi_os_printf("Package        %3d\n",
+		acpi_os_printf("Package        %3lu\n",
 			       sizeof(struct acpi_object_package));
-		acpi_os_printf("BufferField    %3d\n",
+		acpi_os_printf("BufferField    %3lu\n",
 			       sizeof(struct acpi_object_buffer_field));
-		acpi_os_printf("Device         %3d\n",
+		acpi_os_printf("Device         %3lu\n",
 			       sizeof(struct acpi_object_device));
-		acpi_os_printf("Event          %3d\n",
+		acpi_os_printf("Event          %3lu\n",
 			       sizeof(struct acpi_object_event));
-		acpi_os_printf("Method         %3d\n",
+		acpi_os_printf("Method         %3lu\n",
 			       sizeof(struct acpi_object_method));
-		acpi_os_printf("Mutex          %3d\n",
+		acpi_os_printf("Mutex          %3lu\n",
 			       sizeof(struct acpi_object_mutex));
-		acpi_os_printf("Region         %3d\n",
+		acpi_os_printf("Region         %3lu\n",
 			       sizeof(struct acpi_object_region));
-		acpi_os_printf("PowerResource  %3d\n",
+		acpi_os_printf("PowerResource  %3lu\n",
 			       sizeof(struct acpi_object_power_resource));
-		acpi_os_printf("Processor      %3d\n",
+		acpi_os_printf("Processor      %3lu\n",
 			       sizeof(struct acpi_object_processor));
-		acpi_os_printf("ThermalZone    %3d\n",
+		acpi_os_printf("ThermalZone    %3lu\n",
 			       sizeof(struct acpi_object_thermal_zone));
-		acpi_os_printf("RegionField    %3d\n",
+		acpi_os_printf("RegionField    %3lu\n",
 			       sizeof(struct acpi_object_region_field));
-		acpi_os_printf("BankField      %3d\n",
+		acpi_os_printf("BankField      %3lu\n",
 			       sizeof(struct acpi_object_bank_field));
-		acpi_os_printf("IndexField     %3d\n",
+		acpi_os_printf("IndexField     %3lu\n",
 			       sizeof(struct acpi_object_index_field));
-		acpi_os_printf("Reference      %3d\n",
+		acpi_os_printf("Reference      %3lu\n",
 			       sizeof(struct acpi_object_reference));
-		acpi_os_printf("Notify         %3d\n",
+		acpi_os_printf("Notify         %3lu\n",
 			       sizeof(struct acpi_object_notify_handler));
-		acpi_os_printf("AddressSpace   %3d\n",
+		acpi_os_printf("AddressSpace   %3lu\n",
 			       sizeof(struct acpi_object_addr_handler));
-		acpi_os_printf("Extra          %3d\n",
+		acpi_os_printf("Extra          %3lu\n",
 			       sizeof(struct acpi_object_extra));
-		acpi_os_printf("Data           %3d\n",
+		acpi_os_printf("Data           %3lu\n",
 			       sizeof(struct acpi_object_data));
 
 		acpi_os_printf("\n");
 
-		acpi_os_printf("ParseObject    %3d\n",
+		acpi_os_printf("ParseObject    %3lu\n",
 			       sizeof(struct acpi_parse_obj_common));
-		acpi_os_printf("ParseObjectNamed %3d\n",
+		acpi_os_printf("ParseObjectNamed %3lu\n",
 			       sizeof(struct acpi_parse_obj_named));
-		acpi_os_printf("ParseObjectAsl %3d\n",
+		acpi_os_printf("ParseObjectAsl %3lu\n",
 			       sizeof(struct acpi_parse_obj_asl));
-		acpi_os_printf("OperandObject  %3d\n",
+		acpi_os_printf("OperandObject  %3lu\n",
 			       sizeof(union acpi_operand_object));
-		acpi_os_printf("NamespaceNode  %3d\n",
+		acpi_os_printf("NamespaceNode  %3lu\n",
 			       sizeof(struct acpi_namespace_node));
-		acpi_os_printf("AcpiObject     %3d\n",
+		acpi_os_printf("AcpiObject     %3lu\n",
 			       sizeof(union acpi_object));
 
 		acpi_os_printf("\n");
 
-		acpi_os_printf("Generic State  %3d\n",
+		acpi_os_printf("Generic State  %3lu\n",
 			       sizeof(union acpi_generic_state));
-		acpi_os_printf("Common State   %3d\n",
+		acpi_os_printf("Common State   %3lu\n",
 			       sizeof(struct acpi_common_state));
-		acpi_os_printf("Control State  %3d\n",
+		acpi_os_printf("Control State  %3lu\n",
 			       sizeof(struct acpi_control_state));
-		acpi_os_printf("Update State   %3d\n",
+		acpi_os_printf("Update State   %3lu\n",
 			       sizeof(struct acpi_update_state));
-		acpi_os_printf("Scope State    %3d\n",
+		acpi_os_printf("Scope State    %3lu\n",
 			       sizeof(struct acpi_scope_state));
-		acpi_os_printf("Parse Scope    %3d\n",
+		acpi_os_printf("Parse Scope    %3lu\n",
 			       sizeof(struct acpi_pscope_state));
-		acpi_os_printf("Package State  %3d\n",
+		acpi_os_printf("Package State  %3lu\n",
 			       sizeof(struct acpi_pkg_state));
-		acpi_os_printf("Thread State   %3d\n",
+		acpi_os_printf("Thread State   %3lu\n",
 			       sizeof(struct acpi_thread_state));
-		acpi_os_printf("Result Values  %3d\n",
+		acpi_os_printf("Result Values  %3lu\n",
 			       sizeof(struct acpi_result_values));
-		acpi_os_printf("Notify Info    %3d\n",
+		acpi_os_printf("Notify Info    %3lu\n",
 			       sizeof(struct acpi_notify_info));
 		break;
 
diff --git a/drivers/acpi/acpica/utdebug.c b/drivers/acpi/acpica/utdebug.c
index 5744222..4ac231a 100644
--- a/drivers/acpi/acpica/utdebug.c
+++ b/drivers/acpi/acpica/utdebug.c
@@ -189,7 +189,7 @@ acpi_debug_print(u32 requested_debug_level,
 	 * Display the module name, current line number, thread ID (if requested),
 	 * current procedure nesting level, and the current procedure name
 	 */
-	acpi_os_printf("%9s-%04ld ", module_name, line_number);
+	acpi_os_printf("%9s-%04u ", module_name, line_number);
 
 #ifdef ACPI_APPLICATION
 	/*
diff --git a/drivers/scsi/esas2r/esas2r_init.c b/drivers/scsi/esas2r/esas2r_init.c
index 78ce4d61..b3f6ff6 100644
--- a/drivers/scsi/esas2r/esas2r_init.c
+++ b/drivers/scsi/esas2r/esas2r_init.c
@@ -237,7 +237,7 @@ static void esas2r_claim_interrupts(struct esas2r_adapter *a)
 		flags |= IRQF_SHARED;
 
 	esas2r_log(ESAS2R_LOG_INFO,
-		   "esas2r_claim_interrupts irq=%d (%p, %s, %x)",
+		   "esas2r_claim_interrupts irq=%d (%p, %s, %lx)",
 		   a->pcid->irq, a, a->name, flags);
 
 	if (request_irq(a->pcid->irq,
diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index 3e84834..34976f9 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1301,7 +1301,7 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
 	ioctl = kzalloc(sizeof(struct atto_express_ioctl), GFP_KERNEL);
 	if (ioctl == NULL) {
 		esas2r_log(ESAS2R_LOG_WARN,
-			   "ioctl_handler kzalloc failed for %d bytes",
+			   "ioctl_handler kzalloc failed for %lu bytes",
 			   sizeof(struct atto_express_ioctl));
 		return -ENOMEM;
 	}
diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 2aca4d1..cdee863 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -198,7 +198,7 @@ static ssize_t write_hw(struct file *file, struct kobject *kobj,
 					      GFP_KERNEL);
 		if (a->local_atto_ioctl == NULL) {
 			esas2r_log(ESAS2R_LOG_WARN,
-				   "write_hw kzalloc failed for %d bytes",
+				   "write_hw kzalloc failed for %lu bytes",
 				   sizeof(struct atto_ioctl));
 			return -ENOMEM;
 		}
@@ -1186,7 +1186,7 @@ retry:
 		} else {
 			esas2r_log(ESAS2R_LOG_CRIT,
 				   "unable to allocate a request for a "
-				   "device reset (%d:%d)!",
+				   "device reset (%d:%llu)!",
 				   cmd->device->id,
 				   cmd->device->lun);
 		}
-- 
2.8.1
