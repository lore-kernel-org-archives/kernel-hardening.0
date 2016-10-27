Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 27 Oct 2016 23:27:47 +0200
From: Pavel Machek <pavel@ucw.cz>
Message-ID: <20161027212747.GA18147@amd>
References: <20161026204748.GA11177@amd>
 <20161027082801.GE3568@worktop.programming.kicks-ass.net>
 <20161027091104.GB19469@amd>
 <20161027093334.GK3102@twins.programming.kicks-ass.net>
 <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <CAGXu5jL=xzyPRQgOp5ON2+X0=5z4-jg4NyFCrTSrRPm5puOm0Q@mail.gmail.com>
Subject: [kernel-hardening] rowhammer protection [was Re: Getting interrupt every million cache
 misses]
To: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >                 if (event)
> >                         perf_event_release_kernel(event);
> >         }
> > }
>=20
> This is pretty cool. Are there workloads other than rowhammer that
> could trip this, and if so, how bad would this delay be for them?
>=20
> At the very least, this could be behind a CONFIG for people that don't
> have a way to fix their RAM refresh timings, etc.

Yes, CONFIG_ is next.

Here's the patch, notice that I reversed the time handling logic -- it
should be correct now.

We can't tell cache misses on different addresses from cache misses on
same address (rowhammer), so this will have false positive. But so
far, my machine seems to work.

Unfortunately, I don't have machine suitable for testing nearby. Can
someone help with testing? [On the other hand... testing this is not
going to be easy. This will probably make problem way harder to
reproduce it in any case...]

I did run rowhammer, and yes, this did trigger and it was getting
delayed -- by factor of 2. That is slightly low -- delay should be
factor of 8 to get guarantees, if I understand things correctly.

Oh and NMI gets quite angry, but that was to be expected.

[  112.476009] perf: interrupt took too long (23660454 > 23654965),
lowering ker
nel.perf_event_max_sample_rate to 250
[  170.224007] INFO: NMI handler (perf_event_nmi_handler) took too
long to run: 55.844 msecs
[  191.872007] INFO: NMI handler (perf_event_nmi_handler) took too
long to run: 55.845 msecs

Best regards,
								Pavel

diff --git a/kernel/events/Makefile b/kernel/events/Makefile
index 2925188..130a185 100644
--- a/kernel/events/Makefile
+++ b/kernel/events/Makefile
@@ -2,7 +2,7 @@ ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_core.o =3D $(CC_FLAGS_FTRACE)
 endif
=20
-obj-y :=3D core.o ring_buffer.o callchain.o
+obj-y :=3D core.o ring_buffer.o callchain.o nohammer.o
=20
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) +=3D hw_breakpoint.o
 obj-$(CONFIG_UPROBES) +=3D uprobes.o
diff --git a/kernel/events/nohammer.c b/kernel/events/nohammer.c
new file mode 100644
index 0000000..01844d2
--- /dev/null
+++ b/kernel/events/nohammer.c
@@ -0,0 +1,66 @@
+/*
+ * Thanks to Peter Zijlstra <peterz@infradead.org>.
+ */
+
+#include <linux/perf_event.h>
+#include <linux/module.h>
+#include <linux/delay.h>
+
+struct perf_event_attr rh_attr =3D {
+	.type	=3D PERF_TYPE_HARDWARE,
+	.config =3D PERF_COUNT_HW_CACHE_MISSES,
+	.size	=3D sizeof(struct perf_event_attr),
+	.pinned	=3D 1,
+	/* FIXME: it is 1000000 per cpu. */
+	.sample_period =3D 500000,
+};
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
+	/* FIXME msec per usec, reverse logic? */
+	if (delta < 64 * NSEC_PER_MSEC)
+		mdelay(56);
+}
+
+static __init int my_module_init(void)
+{
+	int cpu;
+
+	/* XXX borken vs hotplug */
+
+	for_each_online_cpu(cpu) {
+		struct perf_event *event =3D per_cpu(rh_event, cpu);
+
+		event =3D perf_event_create_kernel_counter(&rh_attr, cpu, NULL, rh_overf=
low, NULL);
+		if (!event)
+			pr_err("Not enough resources to initialize nohammer on cpu %d\n", cpu);
+		pr_info("Nohammer initialized on cpu %d\n", cpu);
+	=09
+	}
+	return 0;
+}
+
+static __exit void my_module_exit(void)
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
+module_init(my_module_init);
+module_exit(my_module_exit);


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgScVMACgkQMOfwapXb+vIERQCfcrWB8G5hBRi++XqXSXcn1JPy
/ksAni6y9ZgcouiQJUu0VUstNgefKjgP
=+Oee
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
