Return-Path: <SRS0=NHpJ=4T=lists.openwall.com=kernel-hardening-return-18042-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000EDC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:20:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5C5A62173E
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 19:20:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5C5A62173E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18042-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21926 invoked by uid 550); 2 Mar 2020 19:20:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21906 invoked from network); 2 Mar 2020 19:20:07 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,508,1574150400"; 
   d="scan'208";a="228570400"
Message-ID: <66d6506278121f22c4360110c38ee3653e4fb1c6.camel@linux.intel.com>
Subject: Re: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H . Peter
 Anvin" <hpa@zytor.com>,  Arjan van de Ven <arjan@linux.intel.com>, Rick
 Edgecombe <rick.p.edgecombe@intel.com>, the arch/x86 maintainers
 <x86@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>
Date: Mon, 02 Mar 2020 11:19:55 -0800
In-Reply-To: <202003021107.38017F90@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-10-kristen@linux.intel.com>
	 <202002060428.08B14F1@keescook>
	 <a915e1eb131551aa766fde4c14de5a3e825af667.camel@linux.intel.com>
	 <CAG48ez2SucOZORUhHNxt-9juzqcWjTZRD9E_PhP51LpH1UqeLg@mail.gmail.com>
	 <41d7049cb704007b3cd30a3f48198eebb8a31783.camel@linux.intel.com>
	 <202003021107.38017F90@keescook>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2020-03-02 at 11:08 -0800, Kees Cook wrote:
> On Mon, Mar 02, 2020 at 11:01:56AM -0800, Kristen Carlson Accardi
> wrote:
> > On Thu, 2020-02-06 at 20:27 +0100, Jann Horn wrote:
> > > https://codesearch.debian.net/search?q=%2Fproc%2Fkallsyms&literal=1
> > 
> > I looked through some of these packages as Jann suggested, and it
> > seems
> > like there are several that are using /proc/kallsyms to look for
> > specific symbol names to determine whether some feature has been
> > compiled into the kernel. This practice seems dubious to me,
> > knowing
> > that many kernel symbol names can be changed at any time, but
> > regardless seems to be fairly common.
> 
> Cool, so a sorted censored list is fine for non-root. Would root
> users
> break on a symbol-name-sorted view? (i.e. are two lists needed or can
> we
> stick to one?)
> 

Internally of course we'll always have to have 2 lists. I couldn't find
any examples of even root users needing the list to be in order by
address. At the same time, it feels like a less risky thing to do to
leave root users with the same thing they've always had and only muck
with non-root users.


