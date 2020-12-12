Return-Path: <SRS0=aZWp=FQ=lists.openwall.com=kernel-hardening-return-20604-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFB3C433FE
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Dec 2020 22:35:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7BA4C22D72
	for <kernel-hardening@archiver.kernel.org>; Sat, 12 Dec 2020 22:34:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7BA4C22D72
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20604-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22377 invoked by uid 550); 12 Dec 2020 22:34:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22333 invoked from network); 12 Dec 2020 22:34:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zJ0jbHH7AMH1arKYdIQ2AVOS8WN1cCiUkP26yxPWS/s=;
        b=ExQ3Y8sI+pTTOMR515nJSD8Y3UbHhoCRW7Nf4wReh44vzDH4muNePFAzx3AEg9CX4G
         UbgkETMY6AOLmkpGl7FkM3JowiytrE+wCjc4M7gEiDbgZYF0+BRx994bDE6rPwTraMGB
         1o+HVj7HXiWTYmxJn2XbDwJbWciwRsTuQVO+FLx00W94lDZwtq8y/pAV9U+i1MtPIQt3
         YtoaoGdsWEQEzuMN25f5U6inoM5V4E5Zzt3X2p9ztVFP53SdNpjg0nHs99O+GQjNotey
         1haK1OLbG+9ymGNxcXOW+cLbhGShMs0g+7EIrht3sosMRVmPIOFgIQC8yqm/1Hi7k+JY
         P2rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zJ0jbHH7AMH1arKYdIQ2AVOS8WN1cCiUkP26yxPWS/s=;
        b=s2m83Vpu8LjTH+l7qD3TPnC37LgbvtKjzyg2kp6unEyLBXDQhuK8YlPm6BE6P8CcIU
         sqDrKfOqNGVkcJtioTX9T5lzCq1VfJVItdMsCeN5UsaQ4Ia/1ffAnwdwxqSSFwbM9AQB
         nELdhROuwjo7KLrTaNKbPD8/MWm5TM/Es0fCXMim4yMV5yTbR8k2IJQWa/fZWq7Mbq7I
         RDB5RzI+p7hWnyyL1+p/hNlaHIYVOCh0kdBfiljXNQZ8o8zxHktxfF/efv36740FIPBb
         norac7Ja3VoTKBGEhCSRBCepUDGysvbCMzVzC3kp56aKj+9LBE/YkJWVNYbCMYWISlf5
         apQw==
X-Gm-Message-State: AOAM5327r/XHl4Xv+NMqZJxCL8LLbGmsJOzJwX7bgF1WEsdKVhyUITRH
	ZAwlGOIsFwcmz1T2IFeQi9K8c1SsOsWzUQTMtLE1QmCcmDDb+JeW
X-Google-Smtp-Source: ABdhPJwqVRX+1IYSWTXGlWAvNFFKFwkjzJUcd6a2Z5Nyynr2P3VgDxpBI3I7JbIKgy1HGTek959K4O7iWUxjVCYYDBY=
X-Received: by 2002:a05:6512:3497:: with SMTP id v23mr7760412lfr.74.1607812479380;
 Sat, 12 Dec 2020 14:34:39 -0800 (PST)
MIME-Version: 1.0
References: <X9UjVOuTgwuQwfFk@mailbox.org>
In-Reply-To: <X9UjVOuTgwuQwfFk@mailbox.org>
From: Jann Horn <jannh@google.com>
Date: Sat, 12 Dec 2020 23:34:12 +0100
Message-ID: <CAG48ez3hO9sEGzxQumSvwkS7PgoEprPJnr6MPzLTwosa+uKzsA@mail.gmail.com>
Subject: Re: Kernel complexity
To: stefan.bavendiek@mailbox.org
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 12, 2020 at 9:14 PM <stefan.bavendiek@mailbox.org> wrote:
> Personally I am interested in Linux Kernel Security and especially featur=
es supporting attack surface reduction. In the past I did some work on sand=
boxing features like seccomp support in user space applications. I have bee=
n rather hesitant to get involved here, since I am not a full time develope=
r and certainly not an expert in C programming.

(By the way, one interesting area where upstream development is
currently happening that's related to userspace sandboxing is the
Landlock patchset by Micka=C3=ABl Sala=C3=BCn, which adds an API that allow=
s
unprivileged processes to restrict their filesystem access without
having to mess around with stuff like mount namespaces and broker
processes; the latest version is at
<https://lore.kernel.org/kernel-hardening/20201209192839.1396820-1-mic@digi=
kod.net/>.
That might be relevant to your interests.)

> However I am currently doing a research project that aims to identify ris=
k areas in the kernel by measuring code complexity metrics and assuming thi=
s might help this project, I would like to ask for some feedback in case th=
is work can actually help with this project.
>
> My approach is basically to take a look at the different system calls and=
 measure the complexity of the code involved in their execution. Since code=
 complexity has already been found to have a strong correlation with the pr=
obability of existing vulnerabilities, this might indicate kernel areas tha=
t need a closer look.

Keep in mind that while system calls are one of the main entry points
from userspace into the kernel, and the main way in which userspace
can trigger kernel bugs, syscalls do not necessarily closely
correspond to specific kernel subsystems.

For example, system calls like read() and write() can take a gigantic
number of execution paths because, especially when you take files in
/proc and /sys into consideration, they interact with things all over
the place across the kernel. For example, write() can modify page
tables of other processes, can trigger page allocation and reclaim,
can modify networking configuration, can interact with filesystems and
block devices and networking and user namespace configuration and
pipes, and so on. But the areas that are reachable through this
syscall depend on other ways in which the process is limited - in
particular, what kinds of files it can open.

Also keep in mind that even a simple syscall like getresuid() can,
through the page fault handling code, end up in subsystems related to
filesystems, block devices, networking, graphics and so on - so you'd
probably have to exclude any control flows that go through certain
pieces of core kernel infrastructure.

> Additionally the functionality of the syscall will also be considered for=
 a final risk score, although most of the work for this part has already be=
en done in [1].

That's a paper from 2002 that talks about "UNIX system calls", and
categorizes syscalls like init_module as being of the highest "threat
level" even though that syscall does absolutely nothing unless you're
already root. It also has "denial of service attacks" as the
second-highest "threat level classification", which I don't think
makes any sense - I don't think that current OS kernels are designed
to prevent an attacker with the ability to execute arbitrary syscalls
from userspace from slowing the system down. Fundamentally it looks to
me as if it classifies syscalls by the risk caused if you let an
attacker run arbitrary code in userspace **with root privileges**,
which seems to me like an extremely silly threat model.

> The objective is to create a risk score matrix for linux syscalls that co=
nsists of the functionality risk according to [1], times the measured compl=
exity.

I don't understand why you would multiply functionality risk and
complexity. They're probably more additive than multiplicative, since
in a per-subsystem view, risk caused by functionality and complexity
of the implementation are often completely separate. For example, the
userfaultfd subsystem introduces functionality risk by allowing
attackers to arbitrarily pause the kernel at any copy_from_user()
call, but that doesn't combine with the complexity of the userfaultfd
subsystem, but with the complexity of all copy_from_user() callers
everywhere across the kernel.

> This will (hopefully) be helpful to identify risk areas in the kernel and=
 provide user space developers with an measurement that can help design sec=
ure software and sandboxing features.

I'm not sure whether this would really be all that helpful for
userspace sandboxing decisions - as far as I know, userspace normally
isn't in a position where it can really choose which syscalls it wants
to use, but instead the choice of syscalls to use is driven by the
requirements that userspace has. If you tell userspace that write()
can hit tons of kernel code, it's not like userspace can just stop
using write(); and if you then also tell userspace that pwrite() can
also hit a lot of kernel code, that may be misinterpreted as meaning
that pwrite() adds lots of risk while actually, write() and pwrite()
reach (almost) the same areas of code. Also, the areas of code that a
syscall like write() can hit depend hugely on file system access
policies.

I also don't think that doing something like this on a per-syscall
basis would be very beneficial for informing something like priorities
for auditing kernel code; only a small chunk of the kernel even has
its own syscalls, while most of it receives commands through
more-or-less generic syscalls that are then plumbed through.

> One major aspect I am still not sure about is the challenges regarding th=
e dynamic measure of code path execution. While it is possible to measure t=
he cyclomatic complexity of the kernel code with existing tools, I am not s=
ure how much value the results would have, given that this does not include=
 the dynamic code path behind each syscall. I was thinking of using ftrace =
to follow and measure the execution path. Any feedback and advise on this f=
or this would be appreciated.
