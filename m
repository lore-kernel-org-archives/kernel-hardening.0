Return-Path: <SRS0=NEWz=E3=lists.openwall.com=kernel-hardening-return-20452-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2DECC388F9
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 13:04:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E0BDF22206
	for <kernel-hardening@archiver.kernel.org>; Sat, 21 Nov 2020 13:04:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E0BDF22206
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=misterjones.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20452-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19807 invoked by uid 550); 21 Nov 2020 13:04:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32623 invoked from network); 21 Nov 2020 11:40:47 -0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sat, 21 Nov 2020 11:40:32 +0000
From: Marc Zyngier <maz@misterjones.org>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, linux-arch
 <linux-arch@vger.kernel.org>, Alistair Delva <adelva@google.com>, Kees Cook
 <keescook@chromium.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kernel
 Hardening <kernel-hardening@lists.openwall.com>, Peter Zijlstra
 <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>, Linux Kbuild mailing list
 <linux-kbuild@vger.kernel.org>, PCI <linux-pci@vger.kernel.org>, LKML
 <linux-kernel@vger.kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 clang-built-linux <clang-built-linux@googlegroups.com>, Sami Tolvanen
 <samitolvanen@google.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Will Deacon
 <will@kernel.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
In-Reply-To: <CAKwvOdmk1D0dLDOHEWX=jHpUxUT2JbwgnF62Qv3Rv=coNPadHg@mail.gmail.com>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
 <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
 <CAKwvOdmpBNx9iSguGXivjJ03FaN5rgv2oaXZUQxYPdRccQmdyQ@mail.gmail.com>
 <CAMj1kXEoPEd6GzjL1XuxTPwitbR03BiBEXpAGtUytMj-h=vCkg@mail.gmail.com>
 <CAKwvOdmk1D0dLDOHEWX=jHpUxUT2JbwgnF62Qv3Rv=coNPadHg@mail.gmail.com>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <a578025ea33108773fe9f3f6e1f180b5@misterjones.org>
X-Sender: maz@misterjones.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: ndesaulniers@google.com, ardb@kernel.org, linux-arch@vger.kernel.org, adelva@google.com, keescook@chromium.org, paulmck@kernel.org, kernel-hardening@lists.openwall.com, peterz@infradead.org, gregkh@linuxfoundation.org, masahiroy@kernel.org, linux-kbuild@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, rostedt@goodmis.org, clang-built-linux@googlegroups.com, samitolvanen@google.com, jpoimboe@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@misterjones.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

On 2020-11-20 23:53, Nick Desaulniers wrote:
> On Fri, Nov 20, 2020 at 3:30 PM Ard Biesheuvel <ardb@kernel.org> wrote:
>> 
>> On Fri, 20 Nov 2020 at 21:19, Nick Desaulniers 
>> <ndesaulniers@google.com> wrote:
>> >
>> > On Fri, Nov 20, 2020 at 2:30 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>> > >
>> > > On Thu, 19 Nov 2020 at 00:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
>> > > >
>> > > > Thanks for continuing to drive this series Sami.  For the series,
>> > > >
>> > > > Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>> > > >
>> > > > I did virtualized boot tests with the series applied to aarch64
>> > > > defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
>> > > > with CONFIG_THINLTO.  If you make changes to the series in follow ups,
>> > > > please drop my tested by tag from the modified patches and I'll help
>> > > > re-test.  Some minor feedback on the Kconfig change, but I'll post it
>> > > > off of that patch.
>> > > >
>> > >
>> > > When you say 'virtualized" do you mean QEMU on x86? Or actual
>> > > virtualization on an AArch64 KVM host?
>> >
>> > aarch64 guest on x86_64 host.  If you have additional configurations
>> > that are important to you, additional testing help would be
>> > appreciated.
>> >
>> 
>> Could you run this on an actual phone? Or does Android already ship
>> with this stuff?
> 
> By `this`, if you mean "the LTO series", it has been shipping on
> Android phones for years now, I think it's even required in the latest
> release.
> 
> If you mean "the LTO series + mainline" on a phone, well there's the
> android-mainline of https://android.googlesource.com/kernel/common/,
> in which this series was recently removed in order to facilitate
> rebasing Android's patches on ToT-mainline until getting the series
> landed upstream.  Bit of a chicken and the egg problem there.
> 
> If you mean "the LTO series + mainline + KVM" on a phone; I don't know
> the precise state of aarch64 KVM and Android (Will or Marc would
> know).

If you are lucky enough to have an Android system booting at EL2,
KVM should just works [1], though I haven't tried with this series.

> We did experiment recently with RockPI's for aach64 KVM, IIRC;
> I think Android is tricky as it still requires A64+A32/T32 chipsets,

Which is about 100% of the Android systems at the moment (I don't think
any of the asymmetric SoCs are in the wild yet). It doesn't really 
affect
KVM anyway.

          M.

[1] with the broken firmware gotchas that I believed to be erradicated
8 years ago, but are still prevalent in the Android world: laughable
PSCI implementation, invalid CNTFRQ_EL0...
-- 
Who you jivin' with that Cosmik Debris?
