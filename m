Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 28 Oct 2016 13:21:36 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161028112136.GA5635@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
 <20161027212747.GA18147@amd>
 <20161028095141.GA5806@leverpostej>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20161028095141.GA5806@leverpostej>
Subject: Re: [kernel-hardening] rowhammer protection [was Re: Getting
 interrupt every million cache misses]
To: Mark Rutland <mark.rutland@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> I missed the original, so I've lost some context.

You can read it on lkml, but I guess you did not lose anything
important.

> Has this been tested on a system vulnerable to rowhammer, and if so, was
> it reliable in mitigating the issue?
>=20
> Which particular attack codebase was it tested against?

I have rowhammer-test here,

commit 9824453fff76e0a3f5d1ac8200bc6c447c4fff57
Author: Mark Seaborn <mseaborn@chromium.org>

=2E I do not have vulnerable machine near me, so no "real" tests, but
I'm pretty sure it will make the error no longer reproducible with the
newer version. [Help welcome ;-)]

> > +struct perf_event_attr rh_attr =3D {
> > +	.type	=3D PERF_TYPE_HARDWARE,
> > +	.config =3D PERF_COUNT_HW_CACHE_MISSES,
> > +	.size	=3D sizeof(struct perf_event_attr),
> > +	.pinned	=3D 1,
> > +	/* FIXME: it is 1000000 per cpu. */
> > +	.sample_period =3D 500000,
> > +};
>=20
> I'm not sure that this is general enough to live in core code, because:

Well, I'd like to postpone debate 'where does it live' to the later
stage. The problem is not arch-specific, the solution is not too
arch-specific either. I believe we can use Kconfig to hide it from
users where it does not apply. Anyway, lets decide if it works and
where, first.

> * the precise semantics of performance counter events varies drastically
>   across implementations. PERF_COUNT_HW_CACHE_MISSES, might only map to
>   one particular level of cache, and/or may not be implemented on all
>   cores.

If it maps to one particular cache level, we are fine (or maybe will
trigger protection too often). If some cores are not counted, that's
bad.

> * On some implementations, it may be that the counters are not
>   interchangeable, and for those this would take away
>   PERF_COUNT_HW_CACHE_MISSES from existing users.

Yup. Note that with this kind of protection, one missing performance
counter is likely to be small problem.

> > +	*ts =3D now;
> > +
> > +	/* FIXME msec per usec, reverse logic? */
> > +	if (delta < 64 * NSEC_PER_MSEC)
> > +		mdelay(56);
> > +}
>=20
> If I round-robin my attack across CPUs, how much does this help?

See below for new explanation. With 2 CPUs, we are fine. On monster
big-little 8-core machines, we'd probably trigger protection too
often.

								Pavel

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e24e981..c6ffcaf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -315,6 +315,7 @@ config PGTABLE_LEVELS
=20
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
+source "kernel/events/Kconfig"
=20
 menu "Processor type and features"
=20
diff --git a/kernel/events/Kconfig b/kernel/events/Kconfig
new file mode 100644
index 0000000..7359427
--- /dev/null
+++ b/kernel/events/Kconfig
@@ -0,0 +1,9 @@
+config NOHAMMER
+        tristate "Rowhammer protection"
+        help
+	  Enable rowhammer attack prevention. Will degrade system
+	  performance under attack so much that attack should not
+	  be feasible.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called nohammer.
diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 2925188..03a2785 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -4,6 +4,8 @@ endif
=20
 obj-y :=3D core.o ring_buffer.o callchain.o
=20
+obj-$(CONFIG_NOHAMMER) +=3D nohammer.o
+
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) +=3D hw_breakpoint.o
 obj-$(CONFIG_UPROBES) +=3D uprobes.o
=20
diff --git a/kernel/events/nohammer.c b/kernel/events/nohammer.c
new file mode 100644
index 0000000..d96bacd
--- /dev/null
+++ b/kernel/events/nohammer.c
@@ -0,0 +1,140 @@
+/*
+ * Attempt to prevent rowhammer attack.
+ *
+ * On many new DRAM chips, repeated read access to nearby cells can cause
+ * victim cell to flip bits. Unfortunately, that can be used to gain root
+ * on affected machine, or to execute native code from javascript, escaping
+ * the sandbox.
+ *
+ * Fortunately, a lot of memory accesses is needed between DRAM refresh
+ * cycles. This is rather unusual workload, and we can detect it, and
+ * prevent the DRAM accesses, before bit flips happen.
+ *
+ * Thanks to Peter Zijlstra <peterz@infradead.org>.
+ * Thanks to presentation at blackhat.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+
+static struct perf_event_attr rh_attr =3D {
+	.type	=3D PERF_TYPE_HARDWARE,
+	.config =3D PERF_COUNT_HW_CACHE_MISSES,
+	.size	=3D sizeof(struct perf_event_attr),
+	.pinned	=3D 1,
+	.sample_period =3D 10000,
+};
+
+/*
+ * How often is the DRAM refreshed. Setting it too high is safe.
+ */
+static int dram_refresh_msec =3D 64;
+
+static DEFINE_PER_CPU(struct perf_event *, rh_event);
+static DEFINE_PER_CPU(u64, rh_timestamp);
+
+static void rh_overflow(struct perf_event *event, struct perf_sample_data =
*data, struct pt_regs *regs)
+{
+	u64 *ts =3D this_cpu_ptr(&rh_timestamp); /* this is NMI context */
+	u64 now =3D ktime_get_mono_fast_ns();
+	s64 delta =3D now - *ts;
+
+	*ts =3D now;
+
+	if (delta < dram_refresh_msec * NSEC_PER_MSEC)
+		mdelay(dram_refresh_msec);
+}
+
+static __init int rh_module_init(void)
+{
+	int cpu;
+
+/*
+ * DRAM refresh is every 64 msec. That is not enough to prevent rowhammer.
+ * Some vendors doubled the refresh rate to 32 msec, that helps a lot, but
+ * does not close the attack completely. 8 msec refresh would probably do
+ * that on almost all chips.
+ *
+ * Thinkpad X60 can produce cca 12,200,000 cache misses a second, that's
+ * 780,800 cache misses per 64 msec window.
+ *
+ * X60 is from generation that is not yet vulnerable from rowhammer, and
+ * is pretty slow machine. That means that this limit is probably very
+ * safe on newer machines.
+ */
+	int cache_misses_per_second =3D 12200000;
+
+/*
+ * Maximum permitted utilization of DRAM. Setting this to f will mean that
+ * when more than 1/f of maximum cache-miss performance is used, delay will
+ * be inserted, and will have similar effect on rowhammer as refreshing me=
mory
+ * f times more often.
+ *
+ * Setting this to 8 should prevent the rowhammer attack.
+ */
+	int dram_max_utilization_factor =3D 8;
+
+	/*
+	 * Hardware should be able to do approximately this many
+	 * misses per refresh
+	 */
+	int cache_miss_per_refresh =3D (cache_misses_per_second * dram_refresh_ms=
ec)/1000;
+
+	/*
+	 * So we do not want more than this many accesses to DRAM per
+	 * refresh.
+	 */
+	int cache_miss_limit =3D cache_miss_per_refresh / dram_max_utilization_fa=
ctor;
+
+/*
+ * DRAM is shared between CPUs, but these performance counters are per-CPU.
+ */
+	int max_attacking_cpus =3D 2;
+
+	/*
+	 * We ignore counter overflows "too far away", but some of the
+	 * events might have actually occurent recently. Thus additional
+	 * factor of 2
+	 */
+
+	rh_attr.sample_period =3D cache_miss_limit / (2*max_attacking_cpus);
+
+	printk("Rowhammer protection limit is set to %d cache misses per %d msec\=
n",
+	       (int) rh_attr.sample_period, dram_refresh_msec);
+
+	/* XXX borken vs hotplug */
+
+	for_each_online_cpu(cpu) {
+		struct perf_event *event;
+
+		event =3D perf_event_create_kernel_counter(&rh_attr, cpu, NULL, rh_overf=
low, NULL);
+		per_cpu(rh_event, cpu) =3D event;	=09
+		if (!event) {
+			pr_err("Not enough resources to initialize nohammer on cpu %d\n", cpu);
+			continue;
+		}
+		pr_info("Nohammer initialized on cpu %d\n", cpu);
+	}
+	return 0;
+}
+
+static __exit void rh_module_exit(void)
+{
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		struct perf_event *event =3D per_cpu(rh_event, cpu);
+
+		if (event)
+			perf_event_release_kernel(event);
+	}
+	return;
+}
+
+module_init(rh_module_init);
+module_exit(rh_module_exit);
+
+MODULE_DESCRIPTION("Rowhammer protection");
+//MODULE_LICENSE("GPL v2+");
+MODULE_LICENSE("GPL");


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgTNMAACgkQMOfwapXb+vJRtgCeMcfiwmpXxB3yNeQoHh4T3Avs
4BsAnAp7g0CUbS+FTI0bOuhPsgYKf5BL
=Ngx6
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
