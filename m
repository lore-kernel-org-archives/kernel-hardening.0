Return-Path: <SRS0=2XBq=FS=lists.openwall.com=kernel-hardening-return-20606-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC79EC4361B
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Dec 2020 06:35:01 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id DE3D922583
	for <kernel-hardening@archiver.kernel.org>; Mon, 14 Dec 2020 06:35:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DE3D922583
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20606-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 31833 invoked by uid 550); 14 Dec 2020 06:34:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31795 invoked from network); 14 Dec 2020 06:34:50 -0000
Date: Mon, 14 Dec 2020 07:34:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1607927678;
	bh=PFdUCl8WFGz9qPqdcD2Tr9+/SsvBh7GWXaUkAjQd6os=;
	h=From:To:Cc:Subject:References:In-Reply-To:From;
	b=tXvxBX7rFqX554zBNIQBPUpzY8so3bSwJWE3hK8Fe/VKd0af+sIsIbT4gkwASo6yI
	 LKqf1yIBafo2Isbk+osIMJVs8e800DYXsw0LJIIaBWksyfkoHMlpEegbPoKHrh7B5l
	 qYAT1jxdUn6bE9VbL7gtg53LL+g2MOfNnddzQZT0=
From: Greg KH <gregkh@linuxfoundation.org>
To: stefan.bavendiek@mailbox.org
Cc: Jann Horn <jannh@google.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-hardening@vger.kernel.org
Subject: Re: Kernel complexity
Message-ID: <X9cHepkKe0oSXtUI@kroah.com>
References: <X9UjVOuTgwuQwfFk@mailbox.org>
 <CAG48ez3hO9sEGzxQumSvwkS7PgoEprPJnr6MPzLTwosa+uKzsA@mail.gmail.com>
 <X9ZlyjtwiKEgOl6p@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9ZlyjtwiKEgOl6p@mailbox.org>

On Sun, Dec 13, 2020 at 08:04:42PM +0100, stefan.bavendiek@mailbox.org wrote:
> > I'm not sure whether this would really be all that helpful for
> > userspace sandboxing decisions - as far as I know, userspace normally
> > isn't in a position where it can really choose which syscalls it wants
> > to use, but instead the choice of syscalls to use is driven by the
> > requirements that userspace has. If you tell userspace that write()
> > can hit tons of kernel code, it's not like userspace can just stop
> > using write(); and if you then also tell userspace that pwrite() can
> > also hit a lot of kernel code, that may be misinterpreted as meaning
> > that pwrite() adds lots of risk while actually, write() and pwrite()
> > reach (almost) the same areas of code. Also, the areas of code that a
> > syscall like write() can hit depend hugely on file system access
> > policies.
> 
> Some issues I have come across revolve around how much attention the
> avoidance of certain system calls should get based on the risk.
> Many applications e.g. like "file" include a seccomp filter that
> restricts most systemcalls from ever being used, without using a broker
> architecture. This is feasible for small applications that do not always
> need to do dangerous things like execve or open (for write). 
> This decision is however often made without extensive research on what
> systemcalls provide dangerous functionality. The idea was to change that
> by providing a risk score for systemcalls.

Like Jann said, syscalls is generally _not_ at the correct level to do
something like this.

Consider a single 'read' syscall of 1 byte out of a file.  Should be
pretty trivial, as that read could be on a sysfs file that merely
returns a single value that is stored in kernel memory for a
configuration option.  That's a simple thing, so all is good, right?

But what about sysfs files that change kernel state when you read a
value, depending on the file, that sometimes is the case, right?

Then think about if you read 1 byte on a filesystem, that is a NFS
mounted filesystem over a PPP networking connection on that is connected
on a USB-serial device to the system.  The number of layers involved
here are very very non-trivial, but yet, that was the same single byte
being read in a syscall.

There's loads of "state" in a kernel system for the configuration of the
system and hardware (oh yeah, you need to think about what the hardware
state is, what hardware involved is and the like.

Good luck!

greg k-h
