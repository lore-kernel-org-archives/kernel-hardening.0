Subject: Re: grsecurity updated source code
References: <CADvTj4qE8xKiEC8L5+XNypsTiSbFaBjf+t4ZpDVnVt9RqdcpSQ@mail.gmail.com>
 <CAFUG7CcueM1JmY5N2Fug0e8XSYFpqw=+4Gm4LuaR0Jn8ZzqzUQ@mail.gmail.com>
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Message-ID: <1c349872-a8e4-f4df-3232-16ad3ddf3d51@yahoo.fr>
Date: Sat, 22 Dec 2018 12:38:52 +0100
MIME-Version: 1.0
In-Reply-To: <CAFUG7CcueM1JmY5N2Fug0e8XSYFpqw=+4Gm4LuaR0Jn8ZzqzUQ@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Kk6zZNBFGqorQR5XsAp0YvpVSJOZQka0B"
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Kk6zZNBFGqorQR5XsAp0YvpVSJOZQka0B
Content-Type: multipart/mixed; boundary="u8qMUJYUtHXXXfrvyCQDomZZd9wCOF9o4";
 protected-headers="v1"
From: Lionel Debroux <lionel_debroux@yahoo.fr>
To: kernel-hardening@lists.openwall.com
Message-ID: <1c349872-a8e4-f4df-3232-16ad3ddf3d51@yahoo.fr>
Subject: Re: grsecurity updated source code
References: <CADvTj4qE8xKiEC8L5+XNypsTiSbFaBjf+t4ZpDVnVt9RqdcpSQ@mail.gmail.com>
 <CAFUG7CcueM1JmY5N2Fug0e8XSYFpqw=+4Gm4LuaR0Jn8ZzqzUQ@mail.gmail.com>
In-Reply-To: <CAFUG7CcueM1JmY5N2Fug0e8XSYFpqw=+4Gm4LuaR0Jn8ZzqzUQ@mail.gmail.com>

--u8qMUJYUtHXXXfrvyCQDomZZd9wCOF9o4
Content-Type: multipart/mixed;
 boundary="------------A0AE20BF653171F64F966F7E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------A0AE20BF653171F64F966F7E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Well... the updated grsec patch makes using the outdated Linux 4.4.x
branch _much_ safer on average, even when not taking advantage of the
RAP (patented) and Respectre plugins:
* KERNEXEC, MEMORY_UDEREF, the full versions of CONSTIFY (+ manual
fixes) and RANDSTRUCT, and other hallmark grsec features, close up
immensely more holes than they might (that's unproven, AFAIK) open;
* the patch shows a wide sampling of security-related fixes missing from
4.4.x and sometimes newer official LTS trees;
* various scattered fixes and improvements (e.g. enums instead of ints
as function argument or return types), most of which were already
visible in earlier versions of the grsec patch, are also useful.

The LF and commercial Linux vendors really ought to take advantage of
the contents of that patch, buying some more developer time if they
don't currently have the resources to do so, for both mainline and LTS
kernels to become less insecure, and for the many-year LTS maintenance
figures to be less meaningless ;)


The result of several hours of work browsing through the updated grsec
patch is reproduced below and attached:
* patch review notes I posted on IRC several days ago;
* my patch hunk extractions, << 1% of the size of the grsec patch.
It was interesting, but I don't plan on doing more such work. There are
limits to working as an unpaid volunteer for the benefit of the LF and
large companies who have near-unlimited resources to buy developer time.

These notes and hunks should be a usable starting point for finding the
commit IDs of a number of mainline changes whose backports to LTS trees
are missing, as well as integrating brand-new fixes to mainline :)


"
The grsec diff against mainline 4.4.162, and comparing against 4.4.168
and 4.20-rc7, pinpoints some missing stable backports, e.g. the second
hunk of arch/x86/kernel/ksysfs.c .
Also possibly the first hunk of arch/x86/kernel/kvm.c .

Also missing from 4.4.168 are the "We should not singlestep on the
exception masking instructions" hunks in arch/x86/kernel/kprobes/core.c
and arch/x86/kernel/uprobes.c and the related hunk in
arch/x86/include/asm/insn.h .
This [ku]probes fix is also missing from the 4.9 series.

Besides a backport of L1TF / nosmt and a (better ?) backport of SSBD,
the new grsec patch also shows a backport of kcov.

In arch/x86/kernel/cpu/perf_event.c , get_segment_base(), do I really
see a fix preventing an access to the LDT entry at
&ldt->entries[ldt->size] ?

The arch/x86/kernel/e820.c hunk shows that 4.4.x versions pass the
argument of early_panic() directly to early_printk() + panic(). Too bad
if said argument somehow ends up being a format string. 4.20-rc7 still
behaves that way.

In arch/x86/kernel/fpu/xstate.c , fpu__xstate_clear_all_cpu_caps() and
fpu__init_disable_system_xstate() are only called from that file or an
__init function in arch/x86/kernel/fpu/init.c , so the __init
annotations on these functions look useful.

In arch/x86/kernel/i8259.c , the hunk related to io_apic_irqs is useful,
since that variable is unsigned long.

The format string changes in drivers/acpi/acpica/* are correct and
useful, and at least those from drivers/acpi/acpica/dbinput.c still
apply verbatim to 4.20-rc7.
The constification hunks for drivers/acpi/blacklist.c and
drivers/acpi/bus.c are in 4.20-rc7 but missing from 4.4.168.
So are the constification hunks for drivers/acpi/ec.c ,
drivers/acpi/pci_slot.c , drivers/acpi/processor_pdc.c ,
drivers/acpi/sleep.c , drivers/acpi/thermal.c and the kfree() addition
in drivers/acpi/utils.c.

I remember the drivers/cpufreq/sparc-us3-cpufreq.c hunks from earlier
iterations of the grsec patch; the grsec changes make the code simpler.

The changes in drivers/crypto/marvell/hash.c look like another missing
stable backport.

Likewise for the cleanup in drivers/dma/img-mdc-dma.c .

At least one of the hunks in drivers/gpu/drm/ttm/ttm_page_alloc.c is an
actual fix, not available in 4.20-rc7.
Same type of code in drivers/gpu/drm/ttm/ttm_page_alloc_dma.c .

Various hunks in ISDN and elsewhere constifying the struct kernel_param
* arguments are available in 4.20-rc7 but missing from 4.4.168.

drivers/isdn/isdnloop/isdnloop.c , drivers/isdn/mISDN/tei.c and other
missing backports in ISDN code.

Locking annotations not backported in e.g. drivers/md/dm.c and elsewhere.=

"


Regards,
Lionel Debroux.

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_acpi1.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_acpi1.diff"

diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 2f24b578bcaf..9b5c2ac1739a 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -47,7 +47,7 @@ struct acpi_blacklist_item {
 	u32 is_critical_error;
 };
=20
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata;
+static const struct dmi_system_id acpi_osi_dmi_table[] __initconst;
=20
 /*
  * POLICY: If *anything* doesn't work, put it on the blacklist.
@@ -168,7 +168,7 @@ static int __init dmi_enable_rev_override(const struc=
t dmi_system_id *d)
 }
 #endif
=20
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata =3D {
+static const struct dmi_system_id acpi_osi_dmi_table[] __initconst =3D {=

 	{
 	.callback =3D dmi_disable_osi_vista,
 	.ident =3D "Fujitsu Siemens",
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ca4f28432d87..ae18affb7f4a 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -63,7 +63,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id=
)
 }
 #endif
=20
-static struct dmi_system_id dsdt_dmi_table[] __initdata =3D {
+static const struct dmi_system_id dsdt_dmi_table[] __initconst =3D {
 	/*
 	 * Invoke DSDT corruption work-around on all Toshiba Satellite.
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=3D14679
@@ -79,7 +79,7 @@ static struct dmi_system_id dsdt_dmi_table[] __initdata=
 =3D {
 	{}
 };
 #else
-static struct dmi_system_id dsdt_dmi_table[] __initdata =3D {
+static const struct dmi_system_id dsdt_dmi_table[] __initconst =3D {
 	{}
 };
 #endif
diff --git a/drivers/acpi/blacklist.c b/drivers/acpi/blacklist.c
index 2f24b578bcaf..9b5c2ac1739a 100644
--- a/drivers/acpi/blacklist.c
+++ b/drivers/acpi/blacklist.c
@@ -47,7 +47,7 @@ struct acpi_blacklist_item {
 	u32 is_critical_error;
 };
=20
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata;
+static const struct dmi_system_id acpi_osi_dmi_table[] __initconst;
=20
 /*
  * POLICY: If *anything* doesn't work, put it on the blacklist.
@@ -168,7 +168,7 @@ static int __init dmi_enable_rev_override(const struc=
t dmi_system_id *d)
 }
 #endif
=20
-static struct dmi_system_id acpi_osi_dmi_table[] __initdata =3D {
+static const struct dmi_system_id acpi_osi_dmi_table[] __initconst =3D {=

 	{
 	.callback =3D dmi_disable_osi_vista,
 	.ident =3D "Fujitsu Siemens",
diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index ca4f28432d87..ae18affb7f4a 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -63,7 +63,7 @@ static int set_copy_dsdt(const struct dmi_system_id *id=
)
 }
 #endif
=20
-static struct dmi_system_id dsdt_dmi_table[] __initdata =3D {
+static const struct dmi_system_id dsdt_dmi_table[] __initconst =3D {
 	/*
 	 * Invoke DSDT corruption work-around on all Toshiba Satellite.
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=3D14679
@@ -79,7 +79,7 @@ static struct dmi_system_id dsdt_dmi_table[] __initdata=
 =3D {
 	{}
 };
 #else
-static struct dmi_system_id dsdt_dmi_table[] __initdata =3D {
+static const struct dmi_system_id dsdt_dmi_table[] __initconst =3D {
 	{}
 };
 #endif
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 43f20328f830..c1a103d81f6b 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -1509,7 +1509,7 @@ static int ec_clear_on_resume(const struct dmi_syst=
em_id *id)
 	return 0;
 }
=20
-static struct dmi_system_id ec_dmi_table[] __initdata =3D {
+static const struct dmi_system_id ec_dmi_table[] __initconst =3D {
 	{
 	ec_skip_dsdt_scan, "Compal JFL92", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "COMPAL"),
@@ -1616,7 +1616,7 @@ error:
 	return -ENODEV;
 }
=20
-static int param_set_event_clearing(const char *val, struct kernel_param=
 *kp)
+static int param_set_event_clearing(const char *val, const struct kernel=
_param *kp)
 {
 	int result =3D 0;
=20
@@ -1634,7 +1634,7 @@ static int param_set_event_clearing(const char *val=
, struct kernel_param *kp)
 	return result;
 }
=20
-static int param_get_event_clearing(char *buffer, struct kernel_param *k=
p)
+static int param_get_event_clearing(char *buffer, const struct kernel_pa=
ram *kp)
 {
 	switch (ec_event_clearing) {
 	case ACPI_EC_EVT_TIMING_STATUS:
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 7188e53b6b7c..6012bc465382 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -191,7 +191,7 @@ static int do_sta_before_sun(const struct dmi_system_=
id *d)
 	return 0;
 }
=20
-static struct dmi_system_id acpi_pci_slot_dmi_table[] __initdata =3D {
+static const struct dmi_system_id acpi_pci_slot_dmi_table[] __initconst =
=3D {
 	/*
 	 * Fujitsu Primequest machines will return 1023 to indicate an
 	 * error if the _SUN method is evaluated on SxFy objects that
diff --git a/drivers/acpi/processor_pdc.c b/drivers/acpi/processor_pdc.c
index 7cfbda4d7c51..74f738cb6073 100644
--- a/drivers/acpi/processor_pdc.c
+++ b/drivers/acpi/processor_pdc.c
@@ -173,7 +173,7 @@ static int __init set_no_mwait(const struct dmi_syste=
m_id *id)
 	return 0;
 }
=20
-static struct dmi_system_id processor_idle_dmi_table[] __initdata =3D {
+static const struct dmi_system_id processor_idle_dmi_table[] __initconst=
 =3D {
 	{
 	set_no_mwait, "Extensa 5220", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index 4f07029de209..b57c10b9c75a 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -154,7 +154,7 @@ static int __init init_nvs_nosave(const struct dmi_sy=
stem_id *d)
 	return 0;
 }
=20
-static struct dmi_system_id acpisleep_dmi_table[] __initdata =3D {
+static const struct dmi_system_id acpisleep_dmi_table[] __initconst =3D =
{
 	{
 	.callback =3D init_old_suspend_ordering,
 	.ident =3D "Abit KN9 (nForce4 variant)",
diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 4b3a9e27f1b6..c80f3c28cfb3 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -227,7 +227,7 @@ module_param_cb(trace_method_name, &param_ops_trace_m=
ethod, &trace_method_name,
 module_param_cb(trace_debug_layer, &param_ops_trace_attrib, &acpi_gbl_tr=
ace_dbg_layer, 0644);
 module_param_cb(trace_debug_level, &param_ops_trace_attrib, &acpi_gbl_tr=
ace_dbg_level, 0644);
=20
-static int param_set_trace_state(const char *val, struct kernel_param *k=
p)
+static int param_set_trace_state(const char *val, const struct kernel_pa=
ram *kp)
 {
 	acpi_status status;
 	const char *method =3D trace_method_name;
@@ -263,7 +263,7 @@ static int param_set_trace_state(const char *val, str=
uct kernel_param *kp)
 	return 0;
 }
=20
-static int param_get_trace_state(char *buffer, struct kernel_param *kp)
+static int param_get_trace_state(char *buffer, const struct kernel_param=
 *kp)
 {
 	if (!(acpi_gbl_trace_flags & ACPI_TRACE_ENABLED))
 		return sprintf(buffer, "disable");
@@ -292,7 +292,7 @@ MODULE_PARM_DESC(aml_debug_output,
 		 "To enable/disable the ACPI Debug Object output.");
=20
 /* /sys/module/acpi/parameters/acpica_version */
-static int param_get_acpica_version(char *buffer, struct kernel_param *k=
p)
+static int param_get_acpica_version(char *buffer, const struct kernel_pa=
ram *kp)
 {
 	int result;
=20
diff --git a/drivers/acpi/thermal.c b/drivers/acpi/thermal.c
index 82707f9824ca..a6b19f584e6b 100644
--- a/drivers/acpi/thermal.c
+++ b/drivers/acpi/thermal.c
@@ -1208,7 +1208,7 @@ static int thermal_psv(const struct dmi_system_id *=
d) {
 	return 0;
 }
=20
-static struct dmi_system_id thermal_dmi_table[] __initdata =3D {
+static const struct dmi_system_id thermal_dmi_table[] __initconst =3D {
 	/*
 	 * Award BIOS on this AOpen makes thermal control almost worthless.
 	 * http://bugzilla.kernel.org/show_bug.cgi?id=3D8842

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_acpi2.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_acpi2.diff"

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 08a02cdc737c..1fa97875259f 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -1024,6 +1024,8 @@ EXPORT_SYMBOL_GPL(acpi_subsys_freeze);
=20
 #endif /* CONFIG_PM_SLEEP */
=20
+static void acpi_dev_pm_detach(struct device *dev, bool power_off);
+
 static struct dev_pm_domain acpi_general_pm_domain =3D {
 	.ops =3D {
 		.runtime_suspend =3D acpi_subsys_runtime_suspend,
@@ -1040,6 +1042,7 @@ static struct dev_pm_domain acpi_general_pm_domain =
=3D {
 		.restore_early =3D acpi_subsys_resume_early,
 #endif
 	},
+	.detach =3D acpi_dev_pm_detach
 };
=20
 /**
@@ -1117,7 +1120,6 @@ int acpi_dev_pm_attach(struct device *dev, bool pow=
er_on)
 		acpi_device_wakeup(adev, ACPI_STATE_S0, false);
 	}
=20
-	dev->pm_domain->detach =3D acpi_dev_pm_detach;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_pm_attach);
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 8c5503c0bad7..9e094c5d6d5a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -41,7 +41,6 @@ ACPI_MODULE_NAME("video");
 void acpi_video_unregister_backlight(void);
=20
 static bool backlight_notifier_registered;
-static struct notifier_block backlight_nb;
 static struct work_struct backlight_notify_work;
=20
 static enum acpi_backlight_type acpi_backlight_cmdline =3D acpi_backligh=
t_undef;
@@ -323,6 +322,10 @@ static int acpi_video_backlight_notify(struct notifi=
er_block *nb,
 	return NOTIFY_OK;
 }
=20
+static struct notifier_block backlight_nb =3D {
+	.notifier_call =3D acpi_video_backlight_notify,
+};
+
 /*
  * Determine which type of backlight interface to use on this system,
  * First check cmdline, then dmi quirks, then do autodetect.
@@ -353,8 +356,6 @@ enum acpi_backlight_type acpi_video_get_backlight_typ=
e(void)
 				    &video_caps, NULL);
 		INIT_WORK(&backlight_notify_work,
 			  acpi_video_backlight_notify_work);
-		backlight_nb.notifier_call =3D acpi_video_backlight_notify;
-		backlight_nb.priority =3D 0;
 		if (backlight_register_notifier(&backlight_nb) =3D=3D 0)
 			backlight_notifier_registered =3D true;
 		init_done =3D true;

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_acpi3.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_acpi3.diff"

diff --git a/drivers/acpi/sysfs.c b/drivers/acpi/sysfs.c
index 4b3a9e27f1b6..c80f3c28cfb3 100644
--- a/drivers/acpi/sysfs.c
+++ b/drivers/acpi/sysfs.c
@@ -776,13 +776,13 @@ static void __exit interrupt_stats_exit(void)
 }
=20
 static ssize_t
-acpi_show_profile(struct device *dev, struct device_attribute *attr,
+acpi_show_profile(struct kobject *kobj, struct kobj_attribute *attr,
 		  char *buf)
 {
 	return sprintf(buf, "%d\n", acpi_gbl_FADT.preferred_profile);
 }
=20
-static const struct device_attribute pm_profile_attr =3D
+static const struct kobj_attribute pm_profile_attr =3D
 	__ATTR(pm_profile, S_IRUGO, acpi_show_profile, NULL);
=20
 static ssize_t hotplug_enabled_show(struct kobject *kobj,

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_acpi4.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_acpi4.diff"

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 475c9079bf85..ce3d3248ebe5 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -358,6 +358,7 @@ acpi_evaluate_reference(acpi_handle handle,
 	}
=20
 	if (package->package.count > ACPI_MAX_HANDLES) {
+		kfree(package);
 		return AE_NO_MEMORY;
 	}
 	list->count =3D package->package.count;

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_acpica.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_acpica.diff"

diff --git a/drivers/acpi/acpica/dbhistry.c b/drivers/acpi/acpica/dbhistr=
y.c
index 9c66a9eadd38..b4aa3a6cd5e8 100644
--- a/drivers/acpi/acpica/dbhistry.c
+++ b/drivers/acpi/acpica/dbhistry.c
@@ -155,7 +155,7 @@ void acpi_db_display_history(void)
=20
 	for (i =3D 0; i < acpi_gbl_num_history; i++) {
 		if (acpi_gbl_history_buffer[history_index].command) {
-			acpi_os_printf("%3ld %s\n",
+			acpi_os_printf("%3u %s\n",
 				       acpi_gbl_history_buffer[history_index].
 				       cmd_num,
 				       acpi_gbl_history_buffer[history_index].
diff --git a/drivers/acpi/acpica/dbinput.c b/drivers/acpi/acpica/dbinput.=
c
index 0480254437f1..ce2cfbd6d3bb 100644
--- a/drivers/acpi/acpica/dbinput.c
+++ b/drivers/acpi/acpica/dbinput.c
@@ -604,7 +604,7 @@ static u32 acpi_db_get_line(char *input_buffer)
 	    (acpi_gbl_db_parsed_buf, sizeof(acpi_gbl_db_parsed_buf),
 	     input_buffer)) {
 		acpi_os_printf
-		    ("Buffer overflow while parsing input line (max %u characters)\n",=

+		    ("Buffer overflow while parsing input line (max %lu characters)\n"=
,
 		     sizeof(acpi_gbl_db_parsed_buf));
 		return (0);
 	}
@@ -861,24 +861,24 @@ acpi_db_command_dispatch(char *input_buffer,
=20
 		if (param_count =3D=3D 0) {
 			acpi_os_printf
-			    ("Current debug level for file output is:    %8.8lX\n",
+			    ("Current debug level for file output is:    %8.8X\n",
 			     acpi_gbl_db_debug_level);
 			acpi_os_printf
-			    ("Current debug level for console output is: %8.8lX\n",
+			    ("Current debug level for console output is: %8.8X\n",
 			     acpi_gbl_db_console_debug_level);
 		} else if (param_count =3D=3D 2) {
 			temp =3D acpi_gbl_db_console_debug_level;
 			acpi_gbl_db_console_debug_level =3D
 			    strtoul(acpi_gbl_db_args[1], NULL, 16);
 			acpi_os_printf
-			    ("Debug Level for console output was %8.8lX, now %8.8lX\n",
+			    ("Debug Level for console output was %8.8X, now %8.8X\n",
 			     temp, acpi_gbl_db_console_debug_level);
 		} else {
 			temp =3D acpi_gbl_db_debug_level;
 			acpi_gbl_db_debug_level =3D
 			    strtoul(acpi_gbl_db_args[1], NULL, 16);
 			acpi_os_printf
-			    ("Debug Level for file output was %8.8lX, now %8.8lX\n",
+			    ("Debug Level for file output was %8.8X, now %8.8X\n",
 			     temp, acpi_gbl_db_debug_level);
 		}
 		break;
diff --git a/drivers/acpi/acpica/dbstats.c b/drivers/acpi/acpica/dbstats.=
c
index 4ba0a20811eb..278c696ac715 100644
--- a/drivers/acpi/acpica/dbstats.c
+++ b/drivers/acpi/acpica/dbstats.c
@@ -377,16 +377,17 @@ acpi_status acpi_db_display_statistics(char *type_a=
rg)
 			       "ACPI_TYPE", "NODES", "OBJECTS");
=20
 		for (i =3D 0; i < ACPI_TYPE_NS_NODE_MAX; i++) {
-			acpi_os_printf("%16.16s % 10ld% 10ld\n",
+			acpi_os_printf("%16.16s % 10d% 10d\n",
 				       acpi_ut_get_type_name(i),
 				       acpi_gbl_node_type_count[i],
 				       acpi_gbl_obj_type_count[i]);
 		}
-		acpi_os_printf("%16.16s % 10ld% 10ld\n", "Misc/Unknown",
+
+		acpi_os_printf("%16.16s % 10d% 10d\n", "Misc/Unknown",
 			       acpi_gbl_node_type_count_misc,
 			       acpi_gbl_obj_type_count_misc);
=20
-		acpi_os_printf("%16.16s % 10ld% 10ld\n", "TOTALS:",
+		acpi_os_printf("%16.16s % 10d% 10d\n", "TOTALS:",
 			       acpi_gbl_num_nodes, acpi_gbl_num_objects);
 		break;
=20
@@ -414,16 +415,16 @@ acpi_status acpi_db_display_statistics(char *type_a=
rg)
 	case CMD_STAT_MISC:
=20
 		acpi_os_printf("\nMiscellaneous Statistics:\n\n");
-		acpi_os_printf("Calls to AcpiPsFind:.. ........% 7ld\n",
+		acpi_os_printf("Calls to AcpiPsFind:.. ........% 7u\n",
 			       acpi_gbl_ps_find_count);
-		acpi_os_printf("Calls to AcpiNsLookup:..........% 7ld\n",
+		acpi_os_printf("Calls to AcpiNsLookup:..........% 7u\n",
 			       acpi_gbl_ns_lookup_count);
=20
 		acpi_os_printf("\n");
=20
 		acpi_os_printf("Mutex usage:\n\n");
 		for (i =3D 0; i < ACPI_NUM_MUTEX; i++) {
-			acpi_os_printf("%-28s:     % 7ld\n",
+			acpi_os_printf("%-28s:     % 7u\n",
 				       acpi_ut_get_mutex_name(i),
 				       acpi_gbl_mutex_info[i].use_count);
 		}
@@ -433,87 +434,87 @@ acpi_status acpi_db_display_statistics(char *type_a=
rg)
=20
 		acpi_os_printf("\nInternal object sizes:\n\n");
=20
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
=20
 		acpi_os_printf("\n");
=20
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
=20
 		acpi_os_printf("\n");
=20
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
=20
diff --git a/drivers/acpi/acpica/utdebug.c b/drivers/acpi/acpica/utdebug.=
c
index 4146229103c8..615a20d283b2 100644
--- a/drivers/acpi/acpica/utdebug.c
+++ b/drivers/acpi/acpica/utdebug.c
@@ -193,7 +193,7 @@ acpi_debug_print(u32 requested_debug_level,
 	 * Display the module name, current line number, thread ID (if requeste=
d),
 	 * current procedure nesting level, and the current procedure name
 	 */
-	acpi_os_printf("%9s-%04ld ", module_name, line_number);
+	acpi_os_printf("%9s-%04u ", module_name, line_number);
=20
 #ifdef ACPI_APPLICATION
 	/*

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_firmware1.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_firmware1.diff"

diff --git a/drivers/firmware/google/gsmi.c b/drivers/firmware/google/gsm=
i.c
index f1ab05ea56bb..ab5122883f71 100644
--- a/drivers/firmware/google/gsmi.c
+++ b/drivers/firmware/google/gsmi.c
@@ -709,7 +709,7 @@ static u32 __init hash_oem_table_id(char s[8])
 	return local_hash_64(input, 32);
 }
=20
-static struct dmi_system_id gsmi_dmi_table[] __initdata =3D {
+static const struct dmi_system_id gsmi_dmi_table[] __initconst =3D {
 	{
 		.ident =3D "Google Board",
 		.matches =3D {
diff --git a/drivers/firmware/google/memconsole.c b/drivers/firmware/goog=
le/memconsole.c
index 2f569aaed4c7..3af549743e8e 100644
--- a/drivers/firmware/google/memconsole.c
+++ b/drivers/firmware/google/memconsole.c
@@ -136,7 +136,7 @@ static bool __init found_memconsole(void)
 	return false;
 }
=20
-static struct dmi_system_id memconsole_dmi_table[] __initdata =3D {
+static const struct dmi_system_id memconsole_dmi_table[] __initconst =3D=
 {
 	{
 		.ident =3D "Google Board",
 		.matches =3D {

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_hid.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_hid.diff"

diff --git a/drivers/hid/hid-wiimote-debug.c b/drivers/hid/hid-wiimote-de=
bug.c
index c13fb5bd79e8..55a380241f05 100644
--- a/drivers/hid/hid-wiimote-debug.c
+++ b/drivers/hid/hid-wiimote-debug.c
@@ -66,7 +66,7 @@ static ssize_t wiidebug_eeprom_read(struct file *f, cha=
r __user *u, size_t s,
 	else if (size =3D=3D 0)
 		return -EIO;
=20
-	if (copy_to_user(u, buf, size))
+	if (size > sizeof(buf) || copy_to_user(u, buf, size))
 		return -EFAULT;
=20
 	*off +=3D size;

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_input.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_input.diff"

diff --git a/drivers/input/mousedev.c b/drivers/input/mousedev.c
index 30328e57fdda..095c7dd87eae 100644
--- a/drivers/input/mousedev.c
+++ b/drivers/input/mousedev.c
@@ -750,7 +750,7 @@ static ssize_t mousedev_read(struct file *file, char =
__user *buffer,
=20
 	spin_unlock_irq(&client->packet_lock);
=20
-	if (copy_to_user(buffer, data, count))
+	if (count > sizeof(data) || copy_to_user(buffer, data, count))
 		return -EFAULT;
=20
 	return count;

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_md.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_md.diff"

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index de628883ee3d..61a2b1f2e7a0 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1451,7 +1451,7 @@ static int crypt_alloc_tfms(struct crypt_config *cc=
, char *ciphermode)
 	unsigned i;
 	int err;
=20
-	cc->tfms =3D kmalloc(cc->tfms_count * sizeof(struct crypto_ablkcipher *=
),
+	cc->tfms =3D kzalloc(cc->tfms_count * sizeof(struct crypto_ablkcipher *=
),
 			   GFP_KERNEL);
 	if (!cc->tfms)
 		return -ENOMEM;
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 1b84d2890fbf..ad9a470e5382 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -50,7 +50,7 @@ struct dm_io_client *dm_io_client_create(void)
 	struct dm_io_client *client;
 	unsigned min_ios =3D dm_get_reserved_bio_based_ios();
=20
-	client =3D kmalloc(sizeof(*client), GFP_KERNEL);
+	client =3D kzalloc(sizeof(*client), GFP_KERNEL);
 	if (!client)
 		return ERR_PTR(-ENOMEM);
=20
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 54c308e6704f..531f2e1d767b 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -820,7 +820,7 @@ struct dm_kcopyd_client *dm_kcopyd_client_create(stru=
ct dm_kcopyd_throttle *thro
 	int r =3D -ENOMEM;
 	struct dm_kcopyd_client *kc;
=20
-	kc =3D kmalloc(sizeof(*kc), GFP_KERNEL);
+	kc =3D kzalloc(sizeof(*kc), GFP_KERNEL);
 	if (!kc)
 		return ERR_PTR(-ENOMEM);
=20
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index 74cb7b991d41..a93a4e683999 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -179,7 +179,7 @@ struct dm_region_hash *dm_region_hash_create(
 		;
 	nr_buckets >>=3D 1;
=20
-	rh =3D kmalloc(sizeof(*rh), GFP_KERNEL);
+	rh =3D kzalloc(sizeof(*rh), GFP_KERNEL);
 	if (!rh) {
 		DMERR("unable to allocate region hash memory");
 		return ERR_PTR(-ENOMEM);
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e108deebbaaa..bed5412b51f9 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1121,7 +1121,7 @@ static int snapshot_ctr(struct dm_target *ti, unsig=
ned int argc, char **argv)
 		origin_mode =3D FMODE_WRITE;
 	}
=20
-	s =3D kmalloc(sizeof(*s), GFP_KERNEL);
+	s =3D kzalloc(sizeof(*s), GFP_KERNEL);
 	if (!s) {
 		ti->error =3D "Cannot allocate private snapshot structure";
 		r =3D -ENOMEM;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index bc4e6825ff62..8b36a6fa7ccf 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2838,7 +2837,7 @@ static struct pool *pool_create(struct mapped_devic=
e *pool_md,
 		return (struct pool *)pmd;
 	}
=20
-	pool =3D kmalloc(sizeof(*pool), GFP_KERNEL);
+	pool =3D kzalloc(sizeof(*pool), GFP_KERNEL);
 	if (!pool) {
 		*error =3D "Error allocating memory for pool";
 		err_p =3D ERR_PTR(-ENOMEM);

--------------A0AE20BF653171F64F966F7E
Content-Type: text/x-patch;
 name="grsec_hunks_media.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="grsec_hunks_media.diff"

diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radi=
o-cadet.c
index 82affaedf067..42833ec0020f 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -333,6 +333,8 @@ static ssize_t cadet_read(struct file *file, char __u=
ser *data, size_t count, lo
 	unsigned char readbuf[RDS_BUFFER];
 	int i =3D 0;
=20
+	if (count > RDS_BUFFER)
+		return -EFAULT;
 	mutex_lock(&dev->lock);
 	if (dev->rdsstat =3D=3D 0)
 		cadet_start_rds(dev);
@@ -349,8 +351,9 @@ static ssize_t cadet_read(struct file *file, char __u=
ser *data, size_t count, lo
 		readbuf[i++] =3D dev->rdsbuf[dev->rdsout++];
 	mutex_unlock(&dev->lock);
=20
-	if (i && copy_to_user(data, readbuf, i))
-		return -EFAULT;
+	if (i > sizeof(readbuf) || (i && copy_to_user(data, readbuf, i)))
+		i =3D -EFAULT;
+
 	return i;
 }
=20
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/=
dvb-usb-v2/rtl28xxu.c
index 5a503a6bb8c5..f75b1f831b81 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -1715,7 +1715,7 @@ static int rtl2832u_rc_query(struct dvb_usb_device =
*d)
 		goto exit;
=20
 	ret =3D rtl28xxu_rd_reg(d, IR_RX_BC, &buf[0]);
-	if (ret)
+	if (ret || buf[0] > sizeof(buf))
 		goto err;
=20
 	len =3D buf[0];

--------------A0AE20BF653171F64F966F7E--

--u8qMUJYUtHXXXfrvyCQDomZZd9wCOF9o4--

--Kk6zZNBFGqorQR5XsAp0YvpVSJOZQka0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE3bt9Bno1p6KT7q/zE2Z0SUsm6A4FAlweIkwACgkQE2Z0SUsm
6A6WHBAApmbTYu4z8+gTjP97iGXi9BC9VDPHF0S0DC/9jZkw3OnX/9p/BtFJF6SH
kmLdX5gFJ30s+qNaELsi4IRy6ihQMBTKwsWQQEsUeoM/QZ4gu1NHIYJmdhLNYm1D
g1WohVyrBFvOEdDbQRV816v0S1lhhLo6b3CttmmPCL1l3CHDAn05EuDD07h9EpDn
b4nPw42ctg9L3UhSjYaWtVBY4IM4Dq88LUYXxwrE9065KWF/JnI3H2x02wEBkQkU
dYxkEvg26BIX/RMJwW7xZYqpanUOXCs+VkHxYu51eTMcCrPUjEnb/NNIk3Gce36M
YlJJAaMAcUaDQFZujHLKSjactnVqgDEy/vWyIsbMHXQJHajUxVD1Lx8UMwyLYu4f
6VRUFRzAqFwE8q3PnIsww9gfEqV3Ut0HMhEHsnR39KuSYOfmlo2hnXI2zkkNUoEe
hnWue85S4dl/2CqR9LtxtOqejG++WZ0oXV4vNJsFsF7GFWPJQunqA6XUaFNYXitR
X9nM3KS5uCBAVtmWnGbUHMlFjF7fqikdJ5C20tCAtCVq7rhETfDhwmsngjNO80Ma
q9iSwhLlg1RhHBMdppyxqyQRnxVFhX5glmsGVDLhbXqYoVTXtIk5hz+JUWdpPeva
57rFDzdqTSgxOQLxSp0jb7Xv79ppHpty34duTUkgBk/vAMnoVlE=
=76Fg
-----END PGP SIGNATURE-----

--Kk6zZNBFGqorQR5XsAp0YvpVSJOZQka0B--
