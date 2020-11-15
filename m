Return-Path: <SRS0=dD8K=EV=lists.openwall.com=kernel-hardening-return-20402-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E02C2D0E4
	for <kernel-hardening@archiver.kernel.org>; Sun, 15 Nov 2020 15:00:50 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 35EB8223BD
	for <kernel-hardening@archiver.kernel.org>; Sun, 15 Nov 2020 15:00:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="EZD/DzlI"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 35EB8223BD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20402-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28332 invoked by uid 550); 15 Nov 2020 15:00:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28296 invoked from network); 15 Nov 2020 15:00:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1605452416;
	bh=F66TAJI9SK/qzn2evr+IwjikHX/ReicFWHnJD3HBPG0=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EZD/DzlI9SPGeB+hywHvNb1VccHExoj901QNGoEzLd+ZQiRXQtKTHJG05SS30fvp6
	 zoUGdC5xxMmCIGRcA9fQqW4uocaV86Xi9UoMF5vfQYx7zB/rbku/3lG9/RP1ujvv2R
	 2oFAmaukrPT7FfgRhJUodnLjlQfa+t9bTyUWncno=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Date: Sun, 15 Nov 2020 16:00:01 +0100
From: John Wood <john.wood@gmx.com>
To: Kees Cook <keescook@chromium.org>
Cc: John Wood <john.wood@gmx.com>, Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2 0/8] Fork brute force attack mitigation
Message-ID: <20201115150001.GA3031@ubuntu>
References: <20201025134540.3770-1-john.wood@gmx.com>
 <202011101422.460E046B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202011101422.460E046B@keescook>
X-Provags-ID: V03:K1:ISjXds9wHKZ5BAbHOUmJBWPTD9iO8kss06Rild3RjHOBxgZ9iVM
 c2+92BWBHdMluO8IXQSmC1/uZxFtEL2xcWbEUDlEoxonXL1VbFI+F7GXp5O8kGnS+83cdrs
 S8G9zroWwcvNmmOpcdWt/SF25cz/EHbrCM1dOMGfpaXIwX2gdwiCcBfBEOXOwteOFbm8vdx
 7QBsjUg2AJXqCfCn0IdYg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:bIw1eiiBgIY=:CMWAfnQXh3gjPqt7hrDAqn
 9WeMEzzgxVxSR2LlBUYlA/XnGMp516aEmeM2SJhwJAWNToW2OfMXLxw8VDFKrzapfWncv6V1n
 oxXMzrONfHMBnPRwToxSeloYNdNIivWt21eJR7ZoG/yHxJYuUWoYSEUFP7xytokpLHK8jXoxH
 uSVmeV6ej5XRD65EswCWi8gOvObpcrAJn9ru1bL/vJoCHlDExa3NZnBxvxe/Pz3i9VZccBnSd
 NjgOu5vd8PnXvS+Wn6smCQIFuL3Tig7SfDqvpj3W9UyyFOMNrXrSQzGe+quLSutB/MPygnrEd
 O5AfOZqlqTi4SM5tMkKsVuiG1mcRRmyVhOPm7/PKbice9v/OnEprfEH0fvQ9PKCsuBcY/zk+/
 xzwBGZYLwP+9poYEuicDU1S3ws9QpCRZKwN9ZsolZW1i5c2G/jHmlS9fwjgittaOn7Da6l3Zr
 9FER1K0MpZDkaAvjj3jxXzwWg7bv48O4Sv/OgkeQMYbW6v/eE1Tzh5wnaHLZ1s1jPbO/6INso
 VKa4I3caopNNFx2p7F99n1+fOMYZwo6+R7D+gfOt6ThvHmMIT/S/+2cNOrTVwpv7vB4Ow4bpQ
 zoY56iI76jaa39zwVan5ogiBvNS0ifVmADD+DXsiwP/jvhW0e7MLofJwyko111GkvIIyjZaU1
 mWomdLtJnk2FyYMpa7Y0t1In8rNco4A3CVOZpbbSTQ2lE+houGkK9tpo5wNI5tCq4qviKjJS3
 okUNIWBu57wcBh0bZ0z5BuGEoYEQkM/Etj8ptGwqdrw94S0xBa+aN5wrWRD4aKdOA66G7eZ0U
 VJg8lMB0gS586dXfehAlSb0DN6BnODRNKRO003knDBteXmhmrcrMugt7fjdF0aJ0rM3FjWVKg
 e5unHNxXyyLFviyCMBTw==
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2020 at 04:10:49PM -0800, Kees Cook wrote:
> On Sun, Oct 25, 2020 at 02:45:32PM +0100, John Wood wrote:
> > Attacks against vulnerable userspace applications with the purpose to =
break
> > ASLR or bypass canaries traditionaly use some level of brute force wit=
h the
> > help of the fork system call. This is possible since when creating a n=
ew
> > process using fork its memory contents are the same as those of the pa=
rent
> > process (the process that called the fork system call). So, the attack=
er
> > can test the memory infinite times to find the correct memory values o=
r the
> > correct memory addresses without worrying about crashing the applicati=
on.
> >
> > Based on the above scenario it would be nice to have this detected and
> > mitigated, and this is the goal of this patch serie.
>
> Thanks for preparing the v2! I spent some time looking at this today,
> and I really like how it has been rearranged into an LSM. This feels
> much more natural.

Thank you very much for reviewing this work.

> Various notes:
>
> The locking isn't right; it'll trip with CONFIG_PROVE_LOCKING=3Dy.
> Here's the giant splat:
>
> [    8.205146] brute: Fork brute force attack detected
> [    8.206821]
> [    8.207317] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [    8.209392] WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detect=
ed
> [    8.211852] 5.10.0-rc3 #2 Not tainted
> [    8.213215] -----------------------------------------------------
> [...]

Interesting... My ".config" also have this option "on" but this warning
never appeared. Under what circumstances did it happen? I tested this
patchset with two custom test programs with no problem. Maybe my tests
are not good enough :(

> I think it should be possible to using existing task locking semantics
> to manage the statistics, but I'll need to take a closer look.
>
> > Other implementations
> > ---------------------
> >
> > The public version of grsecurity, as a summary, is based on the idea o=
f
> > delay the fork system call if a child died due to a fatal error. This =
has
> > some issues:
> >
> > 1.- Bad practices: Add delays to the kernel is, in general, a bad idea=
.
> >
> > 2.- Weak points: This protection can be bypassed using two different
> >     methods since it acts only when the fork is called after a child h=
as
> >     crashed.
> >
> >     2.1.- Bypass 1: So, it would still be possible for an attacker to =
fork
> >           a big amount of children (in the order of thousands), then p=
robe
> >           all of them, and finally wait the protection time before rep=
eat
> >           the steps.
> >
> >     2.2.- Bypass 2: This method is based on the idea that the protecti=
on
> >           doesn't act if the parent crashes. So, it would still be pos=
sible
> >           for an attacker to fork a process and probe itself. Then, fo=
rk
> >           the child process and probe itself again. This way, these st=
eps
> >           can be repeated infinite times without any mitigation.
>
> It's good to clarify what the expected behaviors should be; however,
> while working with the resulting system, it wasn't clear what the threat
> model was for this defense. I think we need two things: clear
> descriptions of what is expected to be detected (and what is not), and a
> set of self-tests that can be used to validate those expectations.

Ok, I will make the necessary changes in order to clarify the commented
points. I will also add the self-tests. Thanks for the suggestion.

> Also, what, specifically, does "fatal error" cover? Is it strictly fatal
> signals? (i.e. "error" might refer to exit code, for example.)

Ok, understood.

> >
> > This implementation
> > -------------------
> >
> > The main idea behind this implementation is to improve the existing on=
es
> > focusing on the weak points annotated before. The solution for the fir=
st
> > bypass method is to detect a fast crash rate instead of only one simpl=
e
> > crash. For the second bypass method the solution is to detect both the
> > crash of parent and child processes. Moreover, as a mitigation method =
it is
> > better to kill all the offending tasks involve in the attack instead o=
f use
> > delays.
> >
> > So, the solution to the two bypass methods previously commented is to =
use
> > some statistical data shared across all the processes that can have th=
e
> > same memory contents. Or in other words, a statistical data shared bet=
ween
> > all the fork hierarchy processes after an execve system call.
>
> Hm, is this already tracked in some other way? i.e. the family hierarchy
> of the mm struct? They're only shared on clone, but get totally copied o=
n
> fork(). Should that be the place where this is tracked instead? (i.e. I
> could fork and totally rearrange my VMAs.)

Great, I will give it a try and study this hierarchy. If this is feasible,
the correct path shoud be to create a new security blob hold by the mm
struct? Also, I think that new LSM hooks will be needed to notify the
allocation, release and copy of this structure. What do you think, am I in
the right direction?

> > The purpose of these statistics is to compute the application crash pe=
riod
> > in order to detect an attack. This crash period is the time between th=
e
> > execve system call and the first fault or the time between two consecu=
tives
> > faults, but this has a drawback. If an application crashes once quickl=
y
> > from the execve system call or crashes twice in a short period of time=
 for
> > some reason, a false positive attack will be triggered. To avoid this
> > scenario the shared statistical data holds a list of the i last crashe=
s
> > timestamps and the application crash period is computed as follows:
> >
> > crash_period =3D (n_last_timestamp - n_minus_i_timestamp) / i;
> >
> > This ways, the size of the last crashes timestamps list allows to fine
> > tuning the detection sensibility.
>
> Instead of a list, can't the rate just be calculated on an on-going
> basis?

The first version computed the application crash period on the fly
(without a list) using the accumulated time and the number of faults.

period =3D time_since_execve / faults_since_execve;

But this method has two major drawbacks. The first (noted by Jann Horn),
is that if an application runs for a long time (say, a month) without any
crash, and the detection threshold is set to 30 s (default value), an
attacker can break the app approximately:

30*24*60*60/30 =3D 86400 times

before the detection is triggered.

The second drawback is that if the first fault is fast (from the execve
system call) the detection will be triggered instantly. This is a problem
if an application fails quickly for reasons that are not related to a real
attack.

I think to avoid the first drawback we can compute the crash period using
a kind of weighted average (setting more weight for the last time between
faults). But the second drawback does not go away.

However, with the list we don't have any of the commented drawbacks (only =
a
larger memory footprint and more calculation time).

Any ideas to remove the list are welcome ;)

> > When this crash period falls under a certain threshold there is a clea=
r
> > signal that something malicious is happening. Once detected, the mitig=
ation
> > only kills the processes that share the same statistical data and so, =
all
> > the tasks that can have the same memory contents. This way, an attack =
is
> > rejected.
>
> Here's where I think the threat model needs some more work. The above
> describes what I think is a less common situation. I expect the common
> attack to hold still with a single value, and let the fork/exec spin
> until the value lines up. (i.e. a fork is required.)
>
> Here are the threat scenarios that come to mind for me:
>
> 1- launching (fork/exec) a setuid process repeatedly until you get a
>    desirable memory layout (e.g. what Stack Clash[1] did).
>
> 2- connecting to an exec()ing network daemon (e.g. xinetd) repeatedly
>    until you get a desirable memory layout (e.g. what CTFs do for simple
>    network service[2]).
>
> 3- launching processes _without_ exec (e.g. Android Zygote[3]), and
>    exposing state to attack a sibling.
>
> 4- connecting to a fork()ing network daemon (e.g. apache) repeatedly
>    until you expose the previously-shared memory layout of all the other
>    children (e.g. kind of related to HeartBleed[3], though that was a
>    direct exposure not a crasher).
>
> In each case, a privilege boundary is being crossed (setuid in the first=
,
> priv-changes in the 2nd, and network-to-local in the latter two), so I
> suspect that kind of detail will need to play a part in the design to
> help avoid false positives.

Ok, I will try to play with privilege boundary crossing in the next
version.

> Regardless, when I tested this series, 1 and 3 isn't detected, since
> they pass through an execve(), and I think that needs to be covered as
> well.

Thanks, I will work on it and review the execve case. Also, thanks for
showing me real examples of fork brute force attacks ;)

> [1] https://www.qualys.com/2017/06/19/stack-clash/stack-clash.txt
> [2] https://github.com/BSidesPDX/CTF-2017/blob/master/pwn/200-leek/src/l=
eek.service
> [3] https://link.springer.com/article/10.1007/s10207-018-00425-8
> [4] https://heartbleed.com/
>
> >
> > 1.- Per system enabling: This feature can be enabled at build time usi=
ng
> >     the CONFIG_SECURITY_FORK_BRUTE option or using the visual config
> >     application under the following menu:
> >
> >     Security options ---> Fork brute force attack detection and mitiga=
tion
>
> (there is a built-in boot time disabling too, by changing the lsm=3D
> bootparam)

Thanks, I will add it to the documentation.

> > 2.- Per process enabling/disabling: To allow that specific application=
s can
> >     turn off or turn on the detection and mitigation of a fork brute f=
orce
> >     attack when required, there are two new prctls.
> >
> >     prctl(PR_SECURITY_FORK_BRUTE_ENABLE, 0, 0, 0, 0)
> >     prctl(PR_SECURITY_FORK_BRUTE_DISABLE, 0, 0, 0, 0)
>
> How do you see this being used?

Maybe the PR_SECURITY_FORK_BRUTE_DISABLE prctl can be used by applications
like "runc" (commented below) if we cannot exclude this false positive. I
mean during phases that may need fork and kill in a quick way. Then, durin=
g
other phases, the protection could be enabled again. Makes sense?

> > 3.- Fine tuning: To customize the detection's sensibility there are tw=
o new
> >     sysctl attributes that allow to set the last crashes timestamps li=
st
> >     size and the application crash period threshold (in milliseconds).=
 Both
> >     are accessible through the following files respectively.
> >
> >     /proc/sys/kernel/brute/timestamps_list_size
> >     /proc/sys/kernel/brute/crash_period_threshold
> >
> >     The list size allows to avoid false positives due to crashes unrel=
ated
> >     with a real attack. The period threshold sets the time limit to de=
tect
> >     an attack. And, since a fork brute force attack will be detected i=
f the
> >     application crash period falls under this threshold, the higher th=
is
> >     value, the more sensitive the detection will be.
>
> I wonder if these will be needed as we narrow in on the specific threat
> model (i.e. there will be enough additional signal to obviate this
> tuning).

I agree. If possible, I will remove as much configuration as possible.
Thanks.

> And in testing I found another false positive that I haven't fully
> diagnosed. I found that at boot, with Docker installed, "runc" would
> immediately trip the mitigation. With some debugging added, I looks like
> runc had several forked processes that got SIGKILLed in quick succession=
,
> and then the entire group got killed by Brute. I haven't narrowed down
> what runc is doing here, but it makes me wonder if there might need
> to be an exception for user-space delivered signals, as opposed to
> kernel-delivered signals...

I will try to work on this as well.

> Thanks again for the work! I'm liking the idea of getting a solid
> protection for this. It's been a long-standing hole in upstream. :)

It's a pleasure to work on this protection. This is the perfect task to
learn a lot.

Thank you very much for the review and all the comments. I know this
review was streamed on twitch but, due to my main language is not english,
I cannot follow speech the way I want. Will this video be uploaded to
youtube? There I can turn on the subtitles. This way I can learn and
improve more things. Thanks again.

>
> -Kees
>
> --
> Kees Cook

Regards,
John Wood
