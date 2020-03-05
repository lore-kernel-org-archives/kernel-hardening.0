Return-Path: <SRS0=6zXQ=4W=lists.openwall.com=kernel-hardening-return-18077-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2442C3F2CD
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:40:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 08ACC2073B
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 15:39:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08ACC2073B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=perches.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18077-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21573 invoked by uid 550); 5 Mar 2020 15:39:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21540 invoked from network); 5 Mar 2020 15:39:52 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: coach66_70fd47f5d3b57
X-Filterd-Recvd-Size: 2111
Message-ID: <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
From: Joe Perches <joe@perches.com>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Arvind Sankar
	 <nivedita@alum.mit.edu>, Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, 
 kernel-hardening@lists.openwall.com, Yoshinori Sato
 <ysato@users.sourceforge.jp>,  Rich Felker <dalias@libc.org>,
 linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2020 07:38:01 -0800
In-Reply-To: <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
References: <202003021038.8F0369D907@keescook>
	 <20200305151010.835954-1-nivedita@alum.mit.edu>
	 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-03-05 at 16:18 +0100, John Paul Adrian Glaubitz wrote:
> On 3/5/20 4:10 PM, Arvind Sankar wrote:
> > For security, don't display the kernel's virtual memory layout.
> > 
> > Kees Cook points out:
> > "These have been entirely removed on other architectures, so let's
> > just do the same for ia32 and remove it unconditionally."
> > 
> > 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> > 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> > 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> > fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> > adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> Aww, why wasn't this made configurable? I found these memory map printouts
> very useful for development.

It could be changed from pr_info to pr_devel.

A #define DEBUG would have to be added to emit it.



