Return-Path: <SRS0=syio=4T=lists.openwall.com=kernel-hardening-return-18040-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9635CC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:02:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E32D42072A
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:02:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E32D42072A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18040-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11564 invoked by uid 550); 2 Mar 2020 19:02:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11544 invoked from network); 2 Mar 2020 19:02:10 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,507,1574150400"; 
   d="scan'208";a="273846472"
Message-ID: <41d7049cb704007b3cd30a3f48198eebb8a31783.camel@linux.intel.com>
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>,
  Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter
 Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@linux.intel.com>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, the arch/x86 maintainers
 <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>
Date: Mon, 02 Mar 2020 11:01:56 -0800
In-Reply-To: <CAG48ez2SucOZORUhHNxt-9juzqcWjTZRD9E_PhP51LpH1UqeLg@mail.gmail.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-10-kristen@linux.intel.com>
	 <202002060428.08B14F1@keescook>
	 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
	 <CAG48ez2SucOZORUhHNxt-9juzqcWjTZRD9E_PhP51LpH1UqeLg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 20:27 +0100, Jann Horn wrote:
> On Thu, Feb 6, 2020 at 6:51 PM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> > On Thu, 2020-02-06 at 04:32 -0800, Kees Cook wrote:
> > > In the past, making kallsyms entirely unreadable seemed to break
> > > weird
> > > stuff in userspace. How about having an alternative view that
> > > just
> > > contains a alphanumeric sort of the symbol names (and they will
> > > continue
> > > to have zeroed addresses for unprivileged users)?
> > > 
> > > Or perhaps we wait to hear about this causing a problem, and deal
> > > with
> > > it then? :)
> > > 
> > 
> > Yeah - I don't know what people want here. Clearly, we can't leave
> > kallsyms the way it is. Removing it entirely is a pretty fast way
> > to
> > figure out how people use it though :).
> 
> FYI, a pretty decent way to see how people are using an API is
> codesearch.debian.net, which searches through the source code of all
> the packages debian ships:
> 
> https://codesearch.debian.net/search?q=%2Fproc%2Fkallsyms&literal=1

I looked through some of these packages as Jann suggested, and it seems
like there are several that are using /proc/kallsyms to look for
specific symbol names to determine whether some feature has been
compiled into the kernel. This practice seems dubious to me, knowing
that many kernel symbol names can be changed at any time, but
regardless seems to be fairly common.



