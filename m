Return-Path: <SRS0=MOtv=AH=lists.openwall.com=kernel-hardening-return-19177-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B419FC433DF
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 13:17:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E48C2080C
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Jun 2020 13:17:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E48C2080C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19177-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1837 invoked by uid 550); 26 Jun 2020 13:17:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1805 invoked from network); 26 Jun 2020 13:17:31 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TEpxwyqxU/CXnVQNUqgC4JtnG+1gAIg8SLvP9r7YDQs=;
        b=ftMQGkjRknTZrlowXH68rN6KNbhbtUBvc0HrvQKELtklhoionpDnqUOQrx+Wrak2vX
         dKLj57LaFXuEvd/BulM7SuEunvYQl0ou2+R7jEhnan/RYRB+xHTcuwKEraLkudFt+6LJ
         BVUq/EZVbVlN3QuqwiOQWb/j/M5mRA3iQJgVcsFj8U8Rc0c+A8zitE0NNBR1nAowI7bf
         v4Z03gmYCy1iwH2XmEjdIYYGoVwhB/TPzAalpxKaFG04iVOZak9BgQ5CsMgC7qSaNNba
         f66K3zX+a1yw++lTkxQlB5QHaOEpUgkRGFLkc+F1pWUmn9/nKdDRzGryE1/nXW3Y+I4p
         6DJg==
X-Gm-Message-State: AOAM530sh7Hx/w0/I4q5K2vsXFVxoMOQAPhbyaKZFSyBMaksRQh6iY36
	WcfUDKNCcunuNMJtSwL4mtsCiIJlMIgIbAq/E0Q=
X-Google-Smtp-Source: ABdhPJyMDD4C50COKuuFiVYxSlLVuYKRyZWoBsls7kAHGP6D2L4tgrB28JwOI/k3pEfxBKTMMOieqO23bboqAtM/1iI=
X-Received: by 2002:a05:6830:10ca:: with SMTP id z10mr2243614oto.167.1593177439501;
 Fri, 26 Jun 2020 06:17:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200530143430.5203-1-oscar.carter@gmx.com> <07911cc62ef21900c43aeefbcbfc8d9f@kernel.org>
In-Reply-To: <07911cc62ef21900c43aeefbcbfc8d9f@kernel.org>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Fri, 26 Jun 2020 15:17:08 +0200
Message-ID: <CAJZ5v0gJJsLyWokpVT8Cy-h+GE5nyqGip_Log1L9i5z+x+nTwg@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] drivers/acpi: Remove function callback casts
To: Marc Zyngier <maz@kernel.org>
Cc: Oscar Carter <oscar.carter@gmx.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, 
	Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Jason Cooper <jason@lakedaemon.net>, Len Brown <lenb@kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

On Fri, Jun 26, 2020 at 3:07 PM Marc Zyngier <maz@kernel.org> wrote:
>
> Hi Rafael,
>
> On 2020-05-30 15:34, Oscar Carter wrote:
> > In an effort to enable -Wcast-function-type in the top-level Makefile
> > to
> > support Control Flow Integrity builds, there are the need to remove all
> > the function callback casts in the acpi driver.
> >
> > The first patch creates a macro called
> > ACPI_DECLARE_SUBTABLE_PROBE_ENTRY
> > to initialize the acpi_probe_entry struct using the probe_subtbl field
> > instead of the probe_table field to avoid function cast mismatches.
> >
> > The second patch modifies the IRQCHIP_ACPI_DECLARE macro to use the new
> > defined macro ACPI_DECLARE_SUBTABLE_PROBE_ENTRY instead of the macro
> > ACPI_DECLARE_PROBE_ENTRY. Also, modifies the prototype of the functions
> > used by the invocation of the IRQCHIP_ACPI_DECLARE macro to match all
> > the
> > parameters.
> >
> > The third patch removes the function cast in the
> > ACPI_DECLARE_PROBE_ENTRY
> > macro to ensure that the functions passed as a last parameter to this
> > macro
> > have the right prototype. This macro is used only in another macro
> > called "TIMER_ACPI_DECLARE". An this is used only in the file:
> >
> > drivers/clocksource/arm_arch_timer.c
> >
> > In this file, the function used in the last parameter of the
> > TIMER_ACPI_DECLARE macro already has the right prototype. So there is
> > no
> > need to modify its prototype.
>
> I'd like to see this into 5.9. Can you please let me know if
> you are OK with the acpi.h changes?

Yes, I am.

> I can queue it via the irqchip tree.

Please do!  Also please feel free to add

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

to the patches.

Thanks!
