Return-Path: <SRS0=ukdM=32=lists.openwall.com=kernel-hardening-return-17718-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9E5C33CAC
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:25:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A95821741
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 17:25:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A95821741
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17718-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32484 invoked by uid 550); 6 Feb 2020 17:25:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32462 invoked from network); 6 Feb 2020 17:25:14 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="232110534"
Message-ID: <9f337efdf226e51e3f5699243623e5de7505ac94.camel@linux.intel.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, 
	arjan@linux.intel.com, rick.p.edgecombe@intel.com, x86@kernel.org, 
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 06 Feb 2020 09:25:01 -0800
In-Reply-To: <20200206145253.GT14914@hirez.programming.kicks-ass.net>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
	 <20200205223950.1212394-9-kristen@linux.intel.com>
	 <20200206103830.GW14879@hirez.programming.kicks-ass.net>
	 <202002060356.BDFEEEFB6C@keescook>
	 <20200206145253.GT14914@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-02-06 at 15:52 +0100, Peter Zijlstra wrote:
> On Thu, Feb 06, 2020 at 04:06:17AM -0800, Kees Cook wrote:
> > On Thu, Feb 06, 2020 at 11:38:30AM +0100, Peter Zijlstra wrote:
> > > On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi
> > > wrote:
> > > > +static long __start___ex_table_addr;
> > > > +static long __stop___ex_table_addr;
> > > > +static long _stext;
> > > > +static long _etext;
> > > > +static long _sinittext;
> > > > +static long _einittext;
> > > 
> > > Should you not also adjust __jump_table, __mcount_loc,
> > > __kprobe_blacklist and possibly others that include text
> > > addresses?
> > 
> > These don't appear to be sorted at build time. 
> 
> The ORC tables are though:
> 
>   57fa18994285 ("scripts/sorttable: Implement build-time ORC unwind
> table sorting")
> 
> > AIUI, the problem with
> > ex_table and kallsyms is that they're preprocessed at build time
> > and
> > opaque to the linker's relocation generation.
> 
> I was under the impression these tables no longer had relocation
> data;
> that since they're part of the main kernel, the final link stage
> could
> completely resolve them.
> 
> That said, I now see we actually have .rela__extable
> .rela.orc_unwind_ip
> etc.

That's right - all of these tables that you mention had relocs and thus
I did not have to do anything special for them. The orc_unwind_ip
tables get sorted during unwind_init(). If they are needed earlier than
that, then they could be re-sorted like we do with the exception table.



