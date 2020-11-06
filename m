Return-Path: <SRS0=XVkB=EM=lists.openwall.com=kernel-hardening-return-20367-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 159BEC4741F
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2020 15:55:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E268B22202
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Nov 2020 15:55:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="aLeMnbTU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E268B22202
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20367-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18120 invoked by uid 550); 6 Nov 2020 15:54:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18085 invoked from network); 6 Nov 2020 15:54:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1604678077;
	bh=bN90BhQTKrUOs+Et5M9q4UcL1zH/Xz1OTeh9A0rIFsg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aLeMnbTUAI2MLyrAtYXe6fzif0ZsBgN30Fs2z68NZLot+wIvJifLb5LcNfLJ0/plO
	 jrZAhEwXb2QbmwIg/tdrFDIQBkzG+19MQhb3zvWkWIUislMHgdMZBH4IASfSM1BS2+
	 Dra9BfMKS8QTG0X0w2MD0vPfayH8rsWVePLzN6x8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Fri, 6 Nov 2020 16:54:23 +0100
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: John Wood <john.wood@gmx.com>, Jonathan Corbet <corbet@lwn.net>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 0/8] Fork brute force attack mitigation
Message-ID: <20201106155423.GA4584@ubuntu>
References: <20201025134540.3770-1-john.wood@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201025134540.3770-1-john.wood@gmx.com>
X-Provags-ID: V03:K1:/AGVpx+PJCtXIg+BTEXY3fG6H8dE9kTzJunPjsCJWC25ThbMP31
 5knBPTcwJUBzY+QS4xIeYCSbgsbjbubvWJ1eGMuVaOER59+d25TeK633OOc4bQzfmj2Pwlr
 KPRIt2wDXCNnU93Zqi1KF9R3G1yG76VTMU1lKTupAJ2GVKTQ7D0oJyYdfMR5QGuhYyD30Q+
 Jzvagaq8rJ2rYPJ/qmBLA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:dK6exDfGB1c=:KYqdZLAKIWR56rpLA/AiKp
 pnT8BQfZVOom0Naetb0rijsOTY+TLJdoyn8bw+Yg/Md3VTunwZH+mA0WHwuoriSsGyKH+Ipw2
 08wqKn3M9/KtTlgC5ji4friyVbUfjxrhGxPK/6xCUXC2kmEQct2yTN7uZU+Vc5+V6GRxyJ1f+
 +l5qa+HlDCxqR55NWq//054XgRIy7RP59fuu5x30+t/qVG6uSoCinpfhRaibkg4WEHxQWGw4Z
 WyLr1mB3O2dHJDwnWOHo8vcQsehyD7Pl6OUo1UUT06pfqRg7ROGlMhNtVZMgrOu72h4fJSqBq
 OUU3VQkQ+a5/NS3aiUt1XOcWwZUlwhoqvCtX0Hf1b2mpGa3WQvl3rFYh1ojR+lIcA3rWk7Wee
 uES1jQ9Op0Tc7F/ESs+2NnTJSCiX5tzMViV0Aq1UXAoYOmoY3CGGwJ3mfL6wEqHwNtarhFpNg
 90jiFrUlHY01m/sdODshkX00S83qYy6rMqafdwWBt43aNKgUGp9iHJqVrLz8P4MiSByumO8Kj
 HMtLOwIUH8yoqD2Biz94dnPLBATZ+6RETAR9dwocTXdQ52BHacMfKnsNZp4lUbJJqTXTVX6/l
 sdWnpZMdrSKh9mHZZL8a0n4nIO3CAJ/BcAjrCRSXM2jRMTMxPlC2DTOEozS7MOaAeL4Rhigu6
 TWiBEXZXsbFD5glBpV0J6BGAkN0y0Rcbo5YXaes4R6GogdZMlq5yuZFHAkh8oC6G0PWDdVY13
 yyMKaWdgLPisFdSF67AvaQrDaYBO/iPIZtHQzqgmDHCeRRJx8V9WAOG+LQsq27gPM0fdLFah2
 eJqLh+KRHMAjKXFdDipVcmK0SxdfpufElq/wWQSdYMN+Bv49/2yR9w6ERkZ0lT7T1RfEIuYBt
 S/uR4PDsERG6wpWrP2Dw==
Content-Transfer-Encoding: quoted-printable

Hi,

Has anyone had time to review this patch serie? Any comments on this?

Regards.

On Sun, Oct 25, 2020 at 02:45:32PM +0100, John Wood wrote:
> Attacks against vulnerable userspace applications with the purpose to br=
eak
> ASLR or bypass canaries traditionaly use some level of brute force with =
the
> help of the fork system call. This is possible since when creating a new
> process using fork its memory contents are the same as those of the pare=
nt
> process (the process that called the fork system call). So, the attacker
> can test the memory infinite times to find the correct memory values or =
the
> correct memory addresses without worrying about crashing the application=
.
>
> Based on the above scenario it would be nice to have this detected and
> mitigated, and this is the goal of this patch serie.
>
> Other implementations
> ---------------------
>
> The public version of grsecurity, as a summary, is based on the idea of
> delay the fork system call if a child died due to a fatal error. This ha=
s
> some issues:
>
> 1.- Bad practices: Add delays to the kernel is, in general, a bad idea.
>
> 2.- Weak points: This protection can be bypassed using two different
>     methods since it acts only when the fork is called after a child has
>     crashed.
>
>     2.1.- Bypass 1: So, it would still be possible for an attacker to fo=
rk
>           a big amount of children (in the order of thousands), then pro=
be
>           all of them, and finally wait the protection time before repea=
t
>           the steps.
>
>     2.2.- Bypass 2: This method is based on the idea that the protection
>           doesn't act if the parent crashes. So, it would still be possi=
ble
>           for an attacker to fork a process and probe itself. Then, fork
>           the child process and probe itself again. This way, these step=
s
>           can be repeated infinite times without any mitigation.
>
> This implementation
> -------------------
>
> The main idea behind this implementation is to improve the existing ones
> focusing on the weak points annotated before. The solution for the first
> bypass method is to detect a fast crash rate instead of only one simple
> crash. For the second bypass method the solution is to detect both the
> crash of parent and child processes. Moreover, as a mitigation method it=
 is
> better to kill all the offending tasks involve in the attack instead of =
use
> delays.
>
> So, the solution to the two bypass methods previously commented is to us=
e
> some statistical data shared across all the processes that can have the
> same memory contents. Or in other words, a statistical data shared betwe=
en
> all the fork hierarchy processes after an execve system call.
>
> The purpose of these statistics is to compute the application crash peri=
od
> in order to detect an attack. This crash period is the time between the
> execve system call and the first fault or the time between two consecuti=
ves
> faults, but this has a drawback. If an application crashes once quickly
> from the execve system call or crashes twice in a short period of time f=
or
> some reason, a false positive attack will be triggered. To avoid this
> scenario the shared statistical data holds a list of the i last crashes
> timestamps and the application crash period is computed as follows:
>
> crash_period =3D (n_last_timestamp - n_minus_i_timestamp) / i;
>
> This ways, the size of the last crashes timestamps list allows to fine
> tuning the detection sensibility.
>
> When this crash period falls under a certain threshold there is a clear
> signal that something malicious is happening. Once detected, the mitigat=
ion
> only kills the processes that share the same statistical data and so, al=
l
> the tasks that can have the same memory contents. This way, an attack is
> rejected.
>
> 1.- Per system enabling: This feature can be enabled at build time using
>     the CONFIG_SECURITY_FORK_BRUTE option or using the visual config
>     application under the following menu:
>
>     Security options ---> Fork brute force attack detection and mitigati=
on
>
> 2.- Per process enabling/disabling: To allow that specific applications =
can
>     turn off or turn on the detection and mitigation of a fork brute for=
ce
>     attack when required, there are two new prctls.
>
>     prctl(PR_SECURITY_FORK_BRUTE_ENABLE, 0, 0, 0, 0)
>     prctl(PR_SECURITY_FORK_BRUTE_DISABLE, 0, 0, 0, 0)
>
> 3.- Fine tuning: To customize the detection's sensibility there are two =
new
>     sysctl attributes that allow to set the last crashes timestamps list
>     size and the application crash period threshold (in milliseconds). B=
oth
>     are accessible through the following files respectively.
>
>     /proc/sys/kernel/brute/timestamps_list_size
>     /proc/sys/kernel/brute/crash_period_threshold
>
>     The list size allows to avoid false positives due to crashes unrelat=
ed
>     with a real attack. The period threshold sets the time limit to dete=
ct
>     an attack. And, since a fork brute force attack will be detected if =
the
>     application crash period falls under this threshold, the higher this
>     value, the more sensitive the detection will be.
>
> So, knowing all this information I will explain now the different patche=
s:
>
> The 1/8 patch defines a new LSM hook to get the fatal signal of a task.
> This will be useful during the attack detection phase.
>
> The 2/8 patch defines a new LSM and manages the statistical data shared =
by
> all the fork hierarchy processes.
>
> The 3/8 patch adds the sysctl attributes to fine tuning the detection.
>
> Patchs 4/8 and 5/8 detect and mitigate a fork brute force attack.
>
> Patch 6/8 adds the prctls to allow per process enabling/disabling.
>
> Patch 7/8 adds the documentation to explain this implementation.
>
> Patch 8/8 updates the maintainers file.
>
> This patch series is a task of the KSPP [1] and can also be accessed fro=
m
> my github tree [2] in the "brute_v2" branch.
>
> [1] https://github.com/KSPP/linux/issues/39
> [2] https://github.com/johwood/linux/
>
> The first version can be found in:
>
> https://lore.kernel.org/kernel-hardening/20200910202107.3799376-1-keesco=
ok@chromium.org/
>
> Changelog RFC -> v2
> -------------------
> - Rename this feature with a more appropiate name (Jann Horn, Kees Cook)=
.
> - Convert the code to an LSM (Kees Cook).
> - Add locking  to avoid data races (Jann Horn).
> - Add a new LSM hook to get the fatal signal of a task (Jann Horn, Kees
>   Cook).
> - Add the last crashes timestamps list to avoid false positives in the
>   attack detection (Jann Horn).
> - Use "period" instead of "rate" (Jann Horn).
> - Other minor changes suggested (Jann Horn, Kees Cook).
>
> John Wood (8):
>   security: Add LSM hook at the point where a task gets a fatal signal
>   security/brute: Define a LSM and manage statistical data
>   security/brute: Add sysctl attributes to allow detection fine tuning
>   security/brute: Detect a fork brute force attack
>   security/brute: Mitigate a fork brute force attack
>   security/brute: Add prctls to enable/disable the fork attack detection
>   Documentation: Add documentation for the Brute LSM
>   MAINTAINERS: Add a new entry for the Brute LSM
>
>  Documentation/admin-guide/LSM/Brute.rst | 118 ++++
>  Documentation/admin-guide/LSM/index.rst |   1 +
>  MAINTAINERS                             |   7 +
>  include/brute/brute.h                   |  16 +
>  include/linux/lsm_hook_defs.h           |   1 +
>  include/linux/lsm_hooks.h               |   4 +
>  include/linux/security.h                |   4 +
>  include/uapi/linux/prctl.h              |   4 +
>  kernel/signal.c                         |   1 +
>  kernel/sys.c                            |   8 +
>  security/Kconfig                        |  11 +-
>  security/Makefile                       |   4 +
>  security/brute/Kconfig                  |  13 +
>  security/brute/Makefile                 |   2 +
>  security/brute/brute.c                  | 749 ++++++++++++++++++++++++
>  security/security.c                     |   5 +
>  16 files changed, 943 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/admin-guide/LSM/Brute.rst
>  create mode 100644 include/brute/brute.h
>  create mode 100644 security/brute/Kconfig
>  create mode 100644 security/brute/Makefile
>  create mode 100644 security/brute/brute.c
>
> --
> 2.25.1
>
