Return-Path: <SRS0=WG/J=5K=lists.openwall.com=kernel-hardening-return-18228-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 634F7C2D0E5
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 20:27:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B87452074D
	for <kernel-hardening@archiver.kernel.org>; Wed, 25 Mar 2020 20:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="V04eeOZm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B87452074D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18228-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16308 invoked by uid 550); 25 Mar 2020 20:27:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 16276 invoked from network); 25 Mar 2020 20:27:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6SzOvwdTQqkZQCjlviRpZUVdzAyX4BMCYO6WRGnsRMg=;
        b=V04eeOZmpXZz9+n2K8s89RAUlNtFI2i3/IBt6L+R3HaP2VRpUcKrX06reMGWIzc2c+
         XwtCJxYWfVvX423KhbuO1h44rQttz9YLq0WAz9cdrMlR19jmIZbXEYme+Erycyi1IU2U
         88GPKoBsjo0xyDjf5T8gvQ6OIx9M3dosv2wAo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6SzOvwdTQqkZQCjlviRpZUVdzAyX4BMCYO6WRGnsRMg=;
        b=SRDHdPchOhgXLkm/z4gBCTvblbOn1GqGqUgEUV54f71hwg67hKiGB44apQVv82jJ2l
         DwxE4HFGnXtcNYJ19qRkn8E/BNiwMo/c3sxov5im9YeNIsj72NfvV2ck82E8LoVegKjh
         IDGb63t6ufUspzMqg/vb5G6fYpbvMfO8AsDIVOKT505TCmC7FbOBQJvQXXsghh317db6
         vVSPQo+rhEmEmuqduZGIQOyIbKYT/N7scS9Y0JC6fZsuqd6sJsSPgLs3GP75+tSvxRr3
         WqbkyXC0TzImwgqg2TTdOHyntymlpmo2BB9VeP3706yKHV4NxCg6Ax9IkUsRKBarUIuI
         InzQ==
X-Gm-Message-State: ANhLgQ3Tk5zfTReNmn2E6sd1xcb/d0Mj/URWDjC9Qip4VngvtvHnJBgW
	eROWpaWnkbuMX21eN+QAt95MQw==
X-Google-Smtp-Source: ADFU+vswtN+46ClgfmDrS2YQ0+gwH0oaxyACQpe8SmgU+n/NeZSp3mJwpEGmc/BXB2B7g4eNvcGW5w==
X-Received: by 2002:a17:902:fe97:: with SMTP id x23mr4918671plm.167.1585168024550;
        Wed, 25 Mar 2020 13:27:04 -0700 (PDT)
Date: Wed, 25 Mar 2020 13:27:02 -0700
From: Kees Cook <keescook@chromium.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: Jann Horn <jannh@google.com>, Thomas Gleixner <tglx@linutronix.de>,
	the arch/x86 maintainers <x86@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linux-MM <linux-mm@kvack.org>,
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] Optionally randomize kernel stack offset each
 syscall
Message-ID: <202003251322.180F2536E@keescook>
References: <20200324203231.64324-1-keescook@chromium.org>
 <CAG48ez3yYkMdxEEW6sJzBC5BZSbzEZKnpWzco32p-TJx7y_srg@mail.gmail.com>
 <202003241604.7269C810B@keescook>
 <BL0PR11MB3281D8D615FA521401B8E320E7CE0@BL0PR11MB3281.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL0PR11MB3281D8D615FA521401B8E320E7CE0@BL0PR11MB3281.namprd11.prod.outlook.com>

On Wed, Mar 25, 2020 at 12:15:12PM +0000, Reshetova, Elena wrote:
> > > Also, are you sure that it isn't possible to make the syscall that
> > > leaked its stack pointer never return to userspace (via ptrace or
> > > SIGSTOP or something like that), and therefore never realign its
> > > stack, while keeping some controlled data present on the syscall's
> > > stack?
> 
> How would you reliably detect that a stack pointer has been leaked
> to userspace while it has been in a syscall? Does not seem to be a trivial
> task to me. 

Well, my expectation is that folks using this defense are also using
panic_on_warn sysctl, etc, so attackers don't get a chance to actually
_use_ register values spilled to dmesg.

-- 
Kees Cook
