Return-Path: <SRS0=cu1X=4Z=lists.openwall.com=kernel-hardening-return-18104-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CD0C10DCE
	for <kernel-hardening@archiver.kernel.org>; Sun,  8 Mar 2020 12:18:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 745112084E
	for <kernel-hardening@archiver.kernel.org>; Sun,  8 Mar 2020 12:18:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 745112084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kaiwantech.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18104-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19918 invoked by uid 550); 8 Mar 2020 12:18:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19880 invoked from network); 8 Mar 2020 12:18:25 -0000
X-CMAE-Analysis: v=2.3 cv=BaWmLYl2 c=1 sm=1 tr=0
 a=Y+b99WSDUBXwRGtcog24Ag==:117 a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19
 a=IkcTkHD0fZMA:10 a=SS2py6AdgQ4A:10 a=1_j9CwCaYTysT8vyirYA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: kaiwan@kaiwantech.com
X-Gm-Message-State: ANhLgQ3TKSU83dN5knLO+QOjFG//+yoyhwfkuSiEOjSug/w3LRkCJzFm
	AIkUOOUpmxM40sPFdnQ8ae2xBH72RseM7Pzufow=
X-Google-Smtp-Source: ADFU+vtZnWMkbiL1bXf+FNyxSs2l/kh0C8lBmhrcLdSBCJkRlC3KOJuhCbp7XEyp4s5Om4jf+N/09525fkXc4ZKhqvc=
X-Received: by 2002:aca:5044:: with SMTP id e65mr8541289oib.28.1583669887378;
 Sun, 08 Mar 2020 05:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <202003021038.8F0369D907@keescook> <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
In-Reply-To: <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
From: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Date: Sun, 8 Mar 2020 17:47:50 +0530
X-Gmail-Original-Message-ID: <CAPDLWs-b0NjDx4A=wdd6aJu84Wrc2wk6QZAf6EYGbqWyy-4ZFw@mail.gmail.com>
Message-ID: <CAPDLWs-b0NjDx4A=wdd6aJu84Wrc2wk6QZAf6EYGbqWyy-4ZFw@mail.gmail.com>
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, Kees Cook <keescook@chromium.org>, 
	"Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-CMAE-Envelope: MS4wfEpHFXeTJaEAZdXiWOnJrDqTUmChY95jfii4FNgvenyqyQCXhYPyh8A/Hd3FUScUqJB23DMcJaJx5UYtf5vVx5680OArOdeKA7+ygN+C9OLqvZCHwWZk
 kSZlaRjKsG5IAaRvwF/LnPwcGVGSy1UcC2cyMQCIrUGMSeZ4oeE5cBBBxJMKyDo3h5Q2Ac9FFWOpKdDrsoUCpU1rx3v/ZR1n/7k=

On Thu, Mar 5, 2020 at 8:48 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
>
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

Same here! IMO, the kernel segment layout is useful for devs/debug purposes.
Perhaps:
a) all these printk's could be gathered into one function and invoked
only when DEBUG (or equivalent) is defined?
b) else, the s/pr_info/pr_devel approach with %pK should be good?
-Kaiwan.
