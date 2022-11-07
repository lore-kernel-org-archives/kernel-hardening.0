Return-Path: <kernel-hardening-return-21577-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 927DCC433FE
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Nov 2022 20:13:54 +0000 (UTC)
Received: (qmail 1314 invoked by uid 550); 7 Nov 2022 20:13:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1279 invoked from network); 7 Nov 2022 20:13:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yObtQ9wJPrlYkrbPvdnk4VcNP5+2kVedV7p00zrzpqk=;
        b=HOMpNU6pIG9ak3/AXz03bACY3qUle3fLU/VLA/B9MwgoIWX+AhFbWitAWrf6kcUXLa
         jNiAW6/0Icd7ZEJI4CzlfnpwO88fkzbNMOKjdYcHMx2LGFk0LJH21udPJFdHSMlEJswV
         PfAGu3QM6OP71N7I4P3S4kGQT9Iw1dzvvkaoP7fJxhT6YF7KU6K7M3mKHpfsoreGHiX1
         l8hS/3GOuWcRF4UXInnYFdnE4j6CvhSub3ZymWotAqGjVZriNU7HqztS6qi88nvaIG7m
         +gPUdqf2Tpf4UJ8kLL9EkoNunqfRoBMilJds1Zsj6W6GapSOMbLoO2MswuSeojqmHqk4
         IRQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yObtQ9wJPrlYkrbPvdnk4VcNP5+2kVedV7p00zrzpqk=;
        b=0pi68qyL+zcuvL7KeXUxLWWm4NJ21O9V3ehG1FHURdQ6HnCk4cMd2NsPfji6/2nbQS
         Iwmh41NV8+mcoBpKHYGthMAvDGWLrIu2yMOWHOfHsngGLCmwrq9vr8YvLoq4GlT0O9lc
         ryuoMHrEEHEhwk8bXpGA1ru7Xd0/Zu1eG65wG6Psg+E2d1kJDr7MbiWGSxrm0YPDzJka
         LZ9C/p55n23m4aqBrMmxy7IoYGSBkmeRGl/cgsLpWse8ZrDJgZhxDK3dS+v8qBkcx+ay
         E8A8g1k4a3n9bgBczvZ6VrdmGD7vTOTCH7mQknKku6Jw9sS5z1i1u2cwS1/Q7BUAkkfv
         QEjA==
X-Gm-Message-State: ACrzQf18IMwE6dDbeSq99b1JlQb/almPASYexJCApAhg34S8jl/az/sQ
	INTI6RGGEAiR4ylHO0354jseLw==
X-Google-Smtp-Source: AMsMyM4b3+XCLhjgUrqMXTfAGe9uH4LbZ+s+iFGzGMlyEel+1kEyciYB99VqzTqw80cLZms5rJtgmA==
X-Received: by 2002:a05:600c:4691:b0:3cf:9cac:85c7 with SMTP id p17-20020a05600c469100b003cf9cac85c7mr11989812wmo.150.1667852010069;
        Mon, 07 Nov 2022 12:13:30 -0800 (PST)
From: Jann Horn <jannh@google.com>
To: Kees Cook <keescook@chromium.org>,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Cc: Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linuxfoundation.org>,
	Seth Jenkins <sethjenkins@google.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] exit: Put an upper limit on how often we can oops
Date: Mon,  7 Nov 2022 21:13:17 +0100
Message-Id: <20221107201317.324457-1-jannh@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Many Linux systems are configured to not panic on oops; but allowing an
attacker to oops the system **really** often can make even bugs that look
completely unexploitable exploitable (like NULL dereferences and such) if
each crash elevates a refcount by one or a lock is taken in read mode, and
this causes a counter to eventually overflow.

The most interesting counters for this are 32 bits wide (like open-coded
refcounts that don't use refcount_t). (The ldsem reader count on 32-bit
platforms is just 16 bits, but probably nobody cares about 32-bit platforms
that much nowadays.)

So let's panic the system if the kernel is constantly oopsing.

The speed of oopsing 2^32 times probably depends on several factors, like
how long the stack trace is and which unwinder you're using; an empirically
important one is whether your console is showing a graphical environment or
a text console that oopses will be printed to.
In a quick single-threaded benchmark, it looks like oopsing in a vfork()
child with a very short stack trace only takes ~510 microseconds per run
when a graphical console is active; but switching to a text console that
oopses are printed to slows it down around 87x, to ~45 milliseconds per
run.
(Adding more threads makes this faster, but the actual oops printing
happens under &die_lock on x86, so you can maybe speed this up by a factor
of around 2 and then any further improvement gets eaten up by lock
contention.)

It looks like it would take around 8-12 days to overflow a 32-bit counter
with repeated oopsing on a multi-core X86 system running a graphical
environment; both me (in an X86 VM) and Seth (with a distro kernel on
normal hardware in a standard configuration) got numbers in that ballpark.

12 days aren't *that* short on a desktop system, and you'd likely need much
longer on a typical server system (assuming that people don't run graphical
desktop environments on their servers), and this is a *very* noisy and
violent approach to exploiting the kernel; and it also seems to take orders
of magnitude longer on some machines, probably because stuff like EFI
pstore will slow it down a ton if that's active.

Signed-off-by: Jann Horn <jannh@google.com>
---
I picked 10000 here to also provide safety for the ldsem code on 32-bit
systems, but you could also argue that the real fix there is to make
ldsem more robust, and that the limit should be something like 2^31...

An alternative approach would be to always let make_task_dead() take the
do_task_dead() path and never exit; but that would probably be a more
disruptive change?

@Kees should this go through your tree? (After waiting a while for
the inevitable bikeshedding on whether the default limit should be closer
to 10000 or 2^31.)

 Documentation/admin-guide/sysctl/kernel.rst |  7 +++++++
 include/linux/panic.h                       |  1 +
 kernel/exit.c                               | 22 +++++++++++++++++++++
 kernel/sysctl.c                             |  7 +++++++
 4 files changed, 37 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/kernel.rst b/Documentation/ad=
min-guide/sysctl/kernel.rst
index 98d1b198b2b4c..09713f25b3d62 100644
--- a/Documentation/admin-guide/sysctl/kernel.rst
+++ b/Documentation/admin-guide/sysctl/kernel.rst
@@ -667,6 +667,13 @@ This is the default behavior.
 an oops event is detected.
=20
=20
+oops_limit
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Number of kernel oopses after which the kernel should panic when
+``panic_on_oops`` is not set.
+
+
 osrelease, ostype & version
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
=20
diff --git a/include/linux/panic.h b/include/linux/panic.h
index c7759b3f20452..5b3e029fe1eb0 100644
--- a/include/linux/panic.h
+++ b/include/linux/panic.h
@@ -21,6 +21,7 @@ extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
 extern int panic_on_io_nmi;
 extern int panic_on_warn;
+extern int oops_limit;
=20
 extern unsigned long panic_on_taint;
 extern bool panic_on_taint_nousertaint;
diff --git a/kernel/exit.c b/kernel/exit.c
index 35e0a31a0315c..827ceffbfa432 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -872,8 +872,17 @@ void __noreturn do_exit(long code)
 	do_task_dead();
 }
=20
+/*
+ * The default value should be high enough to not crash a system that rand=
omly
+ * crashes its kernel from time to time, but low enough to at least not pe=
rmit
+ * overflowing 32-bit refcounts or the ldsem writer count.
+ */
+int oops_limit =3D 10000;
+
 void __noreturn make_task_dead(int signr)
 {
+	static atomic_t oops_count =3D ATOMIC_INIT(0);
+
 	/*
 	 * Take the task off the cpu after something catastrophic has
 	 * happened.
@@ -897,6 +906,19 @@ void __noreturn make_task_dead(int signr)
 		preempt_count_set(PREEMPT_ENABLED);
 	}
=20
+	/*
+	 * Every time the system oopses, if the oops happens while a reference
+	 * to an object was held, the reference leaks.
+	 * If the oops doesn't also leak memory, repeated oopsing can cause
+	 * reference counters to wrap around (if they're not using refcount_t).
+	 * This means that repeated oopsing can make unexploitable-looking bugs
+	 * exploitable through repeated oopsing.
+	 * To make sure this can't happen, place an upper bound on how often the
+	 * kernel may oops without panic().
+	 */
+	if (atomic_inc_return(&oops_count) >=3D READ_ONCE(oops_limit))
+		panic("Oopsed too often (oops_limit is %d)", oops_limit);
+
 	/*
 	 * We're taking recursive faults here in make_task_dead. Safest is to just
 	 * leave this task alone and wait for reboot.
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 188c305aeb8b7..63370aa4c078f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1866,6 +1866,13 @@ static struct ctl_table kern_table[] =3D {
 		.mode		=3D 0644,
 		.proc_handler	=3D proc_dointvec,
 	},
+	{
+		.procname	=3D "oops_limit",
+		.data		=3D &oops_limit,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec,
+	},
 	{
 		.procname	=3D "panic_print",
 		.data		=3D &panic_print,

base-commit: f0c4d9fc9cc9462659728d168387191387e903cc
--=20
2.38.1.431.g37b22c650d-goog

