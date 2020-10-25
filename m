Return-Path: <SRS0=qP95=EA=lists.openwall.com=kernel-hardening-return-20271-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF1ECC55178
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 18:27:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 86B0E21D41
	for <kernel-hardening@archiver.kernel.org>; Sun, 25 Oct 2020 18:27:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="gx2M5Ibx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 86B0E21D41
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20271-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32322 invoked by uid 550); 25 Oct 2020 18:27:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32284 invoked from network); 25 Oct 2020 18:27:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1603650413;
	bh=YBgtMfwJmAL5xT3k46Wa4vvB+Oniw3l18Xi6Adps7Bc=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gx2M5IbxuA/STiTr7+7WRKOkMO76F22KonZwtZAzY+eT/R93QxuJJLRTfzOV+Z2hA
	 FjgvcePMLYv5Spd9Jdv1pe0+tKPDUhB46iokruuFHfFaJtus9GLmErCZOY1maUlbS+
	 JF0KKikw7ZdX3W8kPdfxFi+RiCEeO6PEmM3v+Joc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Jann Horn <jannh@google.com>
Cc: John Wood <john.wood@gmx.com>,
	Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v2 7/8] Documentation: Add documentation for the Brute LSM
Date: Sun, 25 Oct 2020 14:45:39 +0100
Message-Id: <20201025134540.3770-8-john.wood@gmx.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Cz3+eZlgwFAv6f5xHTA4nCXky6FI3BQn9S+EHC231hZb0xz0I6J
 +lavJK3hNxGWnTLOhuYbKVho/t2MC6+tZ4wceYFUzI9ALP6VLisk4OZzyvQymG1z7dpH6Kh
 ZzkSxRDlE2J91ifVTth/f/NashXwCpu9U1kENqxJ4dF4Uig3fiuVuG87PI46uJW2zYj6x0b
 iDJVAsK6IJ266XUmRcIyg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tmic9nfnEuk=:/Vidx7QpmAsEj70awUAUmV
 wsqrWv8AHeZqX9GnoXKwo2sFlzU3AHFYG/jJnLIEyf/R9meSUIaKyvQj0nCuu2sX4q9+v6lXL
 Vsw2MYKW3fAu6di+R1xo5SagAvqTdhOTsPLBDxnPqa6VTTZlMub3S4vTHDdh491keZ4l/MIfO
 yAtVtYqrqHlhFFsJJd7mDs/kzlFsDYshy7dsCqKQ62TR0DXBeJM6JXj+aNJ8IJfOn8iTCvVDA
 /CDVp+DOKOz3m4PxeNNdovSly97f6vwEPUzmFUqGCmTwiyqYCcFl+RBZwJNSFdJQgoP/ODaJW
 4gvTK703KBWTPNnj1EM974ukzylK9M5YQnmiqvLV9/wsL6qA0CLNDmsXJS1Qfo2JiIg8HQC82
 +xhmISUy/4mR/DeNJQOrsO0sHa0ISJtygLppcbfFB6KljibcrPB5QiGGrYateiqTBlD/vhaj/
 xzHk8Vd/svjcHAQ4RoYBemhiRIdf0zCNxrrkiq53xl392oXP/f0URDzZDdRkxxlCVYQXugu6x
 0cQRgXCGBFIKbEU4MHrY+lybYPmnyUvRZr7hxl/MHCdwdM0MR6Nj39kCBOJPldmfjk8gcd64w
 igecjOT3EzXbNhEI22tNjk9K0Bma01JHv66tYUJ+4TCXW58KrSXDCGxY28P1bu2rvYsbiSzRQ
 eyAf2iqz7Zx0ZRWOugJt29BNb1IU8AUe+fbNrJ9UAVxzdcJ2JHMMXiskczHohg/FdEHaS49O7
 pQ5DJQUESQxstFbx6+SoDhQ6NCUjrS1BfluwhdcZ9ihGy3fznQ8BPzTMLHeqLBssdoL626WOk
 6tPvuqCsz44kYJDG6i9pWgbuAWkE1GBjgSgec2N5ZisGhYYwkzsFBR0t/8jQ27f/tFQ7cZjhV
 kPtuuZ2EHpD449w06XBw==

Add some info detailing what is the Brute LSM, its motivation, weak
points of existing implementations, proposed solutions, enabling,
disabling and fine tuning.

Signed-off-by: John Wood <john.wood@gmx.com>
=2D--
 Documentation/admin-guide/LSM/Brute.rst | 118 ++++++++++++++++++++++++
 Documentation/admin-guide/LSM/index.rst |   1 +
 security/brute/Kconfig                  |   3 +-
 3 files changed, 121 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/admin-guide/LSM/Brute.rst

diff --git a/Documentation/admin-guide/LSM/Brute.rst b/Documentation/admin=
-guide/LSM/Brute.rst
new file mode 100644
index 000000000000..20c6ccbd625d
=2D-- /dev/null
+++ b/Documentation/admin-guide/LSM/Brute.rst
@@ -0,0 +1,118 @@
+.. SPDX-License-Identifier: GPL-2.0
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+Brute: Fork brute force attack detection and mitigation LSM
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Attacks against vulnerable userspace applications with the purpose to bre=
ak ASLR
+or bypass canaries traditionaly use some level of brute force with the he=
lp of
+the fork system call. This is possible since when creating a new process =
using
+fork its memory contents are the same as those of the parent process (the
+process that called the fork system call). So, the attacker can test the =
memory
+infinite times to find the correct memory values or the correct memory ad=
dresses
+without worrying about crashing the application.
+
+Based on the above scenario it would be nice to have this detected and
+mitigated, and this is the goal of this implementation.
+
+
+Other implementations
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The public version of grsecurity, as a summary, is based on the idea of d=
elay
+the fork system call if a child died due to a fatal error. This has some =
issues:
+
+Bad practices
+-------------
+
+Add delays to the kernel is, in general, a bad idea.
+
+Weak points
+-----------
+
+This protection can be bypassed using two different methods since it acts=
 only
+when the fork is called after a child has crashed.
+
+Bypass 1
+~~~~~~~~
+
+So, it would still be possible for an attacker to fork a big amount of ch=
ildren
+(in the order of thousands), then probe all of them, and finally wait the
+protection time before repeat the steps.
+
+Bypass 2
+~~~~~~~~
+
+This method is based on the idea that the protection doesn't act if the p=
arent
+crashes. So, it would still be possible for an attacker to fork a process=
 and
+probe itself. Then, fork the child process and probe itself again. This w=
ay,
+these steps can be repeated infinite times without any mitigation.
+
+
+This implementation
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The main idea behind this implementation is to improve the existing ones
+focusing on the weak points annotated before. The solution for the first =
bypass
+method is to detect a fast crash rate instead of only one simple crash. F=
or the
+second bypass method the solution is to detect both the crash of parent a=
nd
+child processes. Moreover, as a mitigation method it is better to kill al=
l the
+offending tasks involve in the attack instead of use delays.
+
+So, the solution to the two bypass methods previously commented is to use=
 some
+statistical data shared across all the processes that can have the same m=
emory
+contents. Or in other words, a statistical data shared between all the fo=
rk
+hierarchy processes after an execve system call.
+
+The purpose of these statistics is to compute the application crash perio=
d in
+order to detect an attack. This crash period is the time between the exec=
ve
+system call and the first fault or the time between two consecutives faul=
ts, but
+this has a drawback. If an application crashes once quickly from the exec=
ve
+system call or crashes twice in a short period of time for some reason, a=
 false
+positive attack will be triggered. To avoid this scenario the shared stat=
istical
+data holds a list of the i last crashes timestamps and the application cr=
ash
+period is computed as follows:
+
+crash_period =3D (n_last_timestamp - n_minus_i_timestamp) / i;
+
+This ways, the size of the last crashes timestamps list allows to fine tu=
ning
+the detection sensibility.
+
+When this crash period falls under a certain threshold there is a clear s=
ignal
+that something malicious is happening. Once detected, the mitigation only=
 kills
+the processes that share the same statistical data and so, all the tasks =
that
+can have the same memory contents. This way, an attack is rejected.
+
+Per system enabling
+-------------------
+
+This feature can be enabled at build time using the CONFIG_SECURITY_FORK_=
BRUTE
+option or using the visual config application under the following menu:
+
+Security options  --->  Fork brute force attack detection and mitigation
+
+Per process enabling/disabling
+------------------------------
+
+To allow that specific applications can turn off or turn on the detection=
 and
+mitigation of a fork brute force attack when required, there are two new =
prctls.
+
+prctl(PR_SECURITY_FORK_BRUTE_ENABLE, 0, 0, 0, 0)  -> To enable the featur=
e
+prctl(PR_SECURITY_FORK_BRUTE_DISABLE, 0, 0, 0, 0) -> To disable the featu=
re
+
+Fine tuning
+-----------
+
+To customize the detection's sensibility there are two new sysctl attribu=
tes
+that allow to set the last crashes timestamps list size and the applicati=
on
+crash period threshold (in milliseconds). Both are accessible through the
+following files respectively.
+
+/proc/sys/kernel/brute/timestamps_list_size
+/proc/sys/kernel/brute/crash_period_threshold
+
+The list size allows to avoid false positives due to crashes unrelated wi=
th a
+real attack. The period threshold sets the time limit to detect an attack=
. And,
+since a fork brute force attack will be detected if the application crash=
 period
+falls under this threshold, the higher this value, the more sensitive the
+detection will be.
+
diff --git a/Documentation/admin-guide/LSM/index.rst b/Documentation/admin=
-guide/LSM/index.rst
index a6ba95fbaa9f..1f68982bb330 100644
=2D-- a/Documentation/admin-guide/LSM/index.rst
+++ b/Documentation/admin-guide/LSM/index.rst
@@ -41,6 +41,7 @@ subdirectories.
    :maxdepth: 1

    apparmor
+   Brute
    LoadPin
    SELinux
    Smack
diff --git a/security/brute/Kconfig b/security/brute/Kconfig
index 1bd2df1e2dec..334d7e88d27f 100644
=2D-- a/security/brute/Kconfig
+++ b/security/brute/Kconfig
@@ -7,6 +7,7 @@ config SECURITY_FORK_BRUTE
 	  vulnerable userspace processes. The detection method is based on
 	  the application crash period and as a mitigation procedure all the
 	  offending tasks are killed. Like capabilities, this security module
-	  stacks with other LSMs.
+	  stacks with other LSMs. Further information can be found in
+	  Documentation/admin-guide/LSM/Brute.rst.

 	  If you are unsure how to answer this question, answer N.
=2D-
2.25.1

