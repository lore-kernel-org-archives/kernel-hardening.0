Return-Path: <SRS0=69je=CD=lists.openwall.com=kernel-hardening-return-19664-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E3E4C433DF
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Aug 2020 16:17:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 856992076C
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Aug 2020 16:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WpBgXc5W"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 856992076C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19664-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24458 invoked by uid 550); 25 Aug 2020 16:17:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24438 invoked from network); 25 Aug 2020 16:17:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1598372210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q3HoWWtTXzG1DNyfWvPLzOd/wEe/1eM21yozmk7l7k0=;
	b=WpBgXc5WNCZPWyBEs6HHZPwMXtAAZyLR4fAhJonSwDLLbt60PW69q8CDFnqLblIf8PShO2
	ZNj9Gxhv9/lPRyhFo4N9qCWpSR8rOib0Wt1SgJQ/zpM0wxQCwWnnJI1C+/haOQl/v34tyT
	tr9UNvDuI5QSHLRZpNJBwImv167HA7g=
X-MC-Unique: uIA61BQsMv-0LkTdrzDS3A-1
Subject: Re: [PATCH v4 00/10] Function Granular KASLR
To: Kristen Carlson Accardi <kristen@linux.intel.com>,
 Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Miroslav Benes <mbenes@suse.cz>,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, arjan@linux.intel.com,
 x86@kernel.org, linux-kernel@vger.kernel.org,
 kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
 live-patching@vger.kernel.org, Hongjiu Lu <hongjiu.lu@intel.com>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <alpine.LSU.2.21.2007221122110.10163@pobox.suse.cz>
 <202007220738.72F26D2480@keescook> <20200722160730.cfhcj4eisglnzolr@treble>
 <202007221241.EBC2215A@keescook>
 <301c7fb7d22ad6ef97856b421873e32c2239d412.camel@linux.intel.com>
 <20200722213313.aetl3h5rkub6ktmw@treble>
 <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
From: Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <a29e8960-916b-8a5b-f8ed-ec040eddbbde@redhat.com>
Date: Tue, 25 Aug 2020 12:16:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <46c49dec078cb8625a9c3a3cd1310a4de7ec760b.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16

On 8/21/20 7:02 PM, Kristen Carlson Accardi wrote:
> On Wed, 2020-07-22 at 16:33 -0500, Josh Poimboeuf wrote:
>> On Wed, Jul 22, 2020 at 12:56:10PM -0700, Kristen Carlson Accardi
>> wrote:
>>> On Wed, 2020-07-22 at 12:42 -0700, Kees Cook wrote:
>>>> On Wed, Jul 22, 2020 at 11:07:30AM -0500, Josh Poimboeuf wrote:
>>>>> On Wed, Jul 22, 2020 at 07:39:55AM -0700, Kees Cook wrote:
>>>>>> On Wed, Jul 22, 2020 at 11:27:30AM +0200, Miroslav Benes
>>>>>> wrote:
>>>>>>> Let me CC live-patching ML, because from a quick glance
>>>>>>> this is
>>>>>>> something
>>>>>>> which could impact live patching code. At least it
>>>>>>> invalidates
>>>>>>> assumptions
>>>>>>> which "sympos" is based on.
>>>>>>
>>>>>> In a quick skim, it looks like the symbol resolution is using
>>>>>> kallsyms_on_each_symbol(), so I think this is safe? What's a
>>>>>> good
>>>>>> selftest for live-patching?
>>>>>
>>>>> The problem is duplicate symbols.  If there are two static
>>>>> functions
>>>>> named 'foo' then livepatch needs a way to distinguish them.
>>>>>
>>>>> Our current approach to that problem is "sympos".  We rely on
>>>>> the
>>>>> fact
>>>>> that the second foo() always comes after the first one in the
>>>>> symbol
>>>>> list and kallsyms.  So they're referred to as foo,1 and foo,2.
>>>>
>>>> Ah. Fun. In that case, perhaps the LTO series has some solutions.
>>>> I
>>>> think builds with LTO end up renaming duplicate symbols like
>>>> that, so
>>>> it'll be back to being unique.
>>>>
>>>
>>> Well, glad to hear there might be some precendence for how to solve
>>> this, as I wasn't able to think of something reasonable off the top
>>> of
>>> my head. Are you speaking of the Clang LTO series?
>>> https://lore.kernel.org/lkml/20200624203200.78870-1-samitolvanen@google.com/
>>
>> I'm not sure how LTO does it, but a few more (half-brained) ideas
>> that
>> could work:
>>
>> 1) Add a field in kallsyms to keep track of a symbol's original
>> offset
>>     before randomization/re-sorting.  Livepatch could use that field
>> to
>>     determine the original sympos.
>>
>> 2) In fgkaslr code, go through all the sections and mark the ones
>> which
>>     have duplicates (i.e. same name).  Then when shuffling the
>> sections,
>>     skip a shuffle if it involves a duplicate section.  That way all
>> the
>>     duplicates would retain their original sympos.
>>
>> 3) Livepatch could uniquely identify symbols by some feature other
>> than
>>     sympos.  For example:
>>
>>     Symbol/function size - obviously this would only work if
>> duplicately
>>     named symbols have different sizes.
>>
>>     Checksum - as part of a separate feature we're also looking at
>> giving
>>     each function its own checksum, calculated based on its
>> instruction
>>     opcodes.  Though calculating checksums at runtime could be
>>     complicated by IP-relative addressing.
>>
>> I'm thinking #1 or #2 wouldn't be too bad.  #3 might be harder.
>>
> 
> Hi there! I was trying to find a super easy way to address this, so I
> thought the best thing would be if there were a compiler or linker
> switch to just eliminate any duplicate symbols at compile time for
> vmlinux. I filed this question on the binutils bugzilla looking to see
> if there were existing flags that might do this, but H.J. Lu went ahead
> and created a new one "-z unique", that seems to do what we would need
> it to do.
> 
> https://sourceware.org/bugzilla/show_bug.cgi?id=26391
> 
> When I use this option, it renames any duplicate symbols with an
> extension - for example duplicatefunc.1 or duplicatefunc.2.

I tried out H.J. Lu's branch and built some of the livepatch selftests 
with -z unique-symbol and indeed observe the following pattern:

  foo, foo.1, foo.2, etc.

for homonym symbol names.

 > You could
> either match on the full unique name of the specific binary you are
> trying to patch, or you match the base name and use the extension to
> determine original position. Do you think this solution would work? 

I think it could work for klp-relocations.

As a quick test, I was able to hack the WIP klp-convert branch [1] to 
generate klp-relocations with the following hack:

   const char *foo(void) __asm__("foo.1");

when building foo's target with -z unique-symbol.  (The target contained 
two static foo() functions.)  The asm rename trick exercised the 
klp-convert implicit conversion feature, as the symbol was now uniquely 
named and included a non-valid C symbol character.  User-defined 
klp-convert annotation support will require some refactoring, but 
shouldn't be too difficult to support as well.

> If
> so, I can modify livepatch to refuse to patch on duplicated symbols if
> CONFIG_FG_KASLR and when this option is merged into the tool chain I
> can add it to KBUILD_LDFLAGS when CONFIG_FG_KASLR and livepatching
> should work in all cases.
> 

I don't have a grasp on how complicated the alternatives might be, so 
I'll let others comment on best paths forward.  I just wanted to note 
that -z unique-symbol looks like it could reasonable work well for this 
niche case.

[1] 
https://github.com/joe-lawrence/linux/tree/klp-convert-v5-expanded-v5.8 
(not modified for -z unique-symbol, but noted for reference)

-- Joe

