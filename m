Return-Path: <SRS0=wHcY=BJ=lists.openwall.com=kernel-hardening-return-19501-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A84C5C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 17:28:46 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0520820809
	for <kernel-hardening@archiver.kernel.org>; Thu, 30 Jul 2020 17:28:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGWbqQEi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0520820809
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19501-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1364 invoked by uid 550); 30 Jul 2020 17:25:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24287 invoked from network); 30 Jul 2020 17:14:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SBf5My5eZ9Wekb7IVsuPtVhYipAan0zbC8RnkLTkJqI=;
        b=hGWbqQEimRseVKiLJ2aLyaeEBNSRa/i3JJph8QSJU0RFkeWBCFppFMJ1SnZ6BKMl3n
         2z67hfVY9sWZ0X92G4+oGBaOnDgLGnu7ruxFA3XwU5VtkftpiqIU0T0Scwn2F1PnTQd+
         sabtmjKSe6hEYW802JfSHRidGBj//9+FYx6cELY//aI739x5c2XnzHytWX5mwfI278bO
         RZXfVPuJno+gzfuo7/5Tpl5WRZJYqJs7Ol54cLwfcp6Usx52b2E4hL2gdv7mKTZtbh5l
         Fkuj9KtTCpJeZQJVeaVF0YjEVPIDBJSVkKkEI5pYdO/kVmMqL1KgU+UJOoF7cUGrlJ1G
         b/Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SBf5My5eZ9Wekb7IVsuPtVhYipAan0zbC8RnkLTkJqI=;
        b=P9B+rpwsBR1MaEMMxaVgV/bib/UJO3/99fA/Q0DJCwuWhPz+B2qDhHZBZ1HanNEax8
         nrhppSDJvDsGKpupzRFVLd/4UPuV057qzefm12Ita2NtWOzTg1fFv5yjosZWCIcYHHHF
         MoKvPymiZSv7zZCVPHmvbocHqYiFAgEY1/iHYbzD6NWQUnKQ+06JXEE5Cr9zWjh7Q9cs
         r9rSaF1EvzJQtW0AGBK7CByMuic904zv+7Ym3xy4PpODY4ZakS0j81Ku+s9NErWeOeGx
         zvd3RkM1gnYuo0C/9OSZnTUuwlouzr8pt7L96mhSrnc0ZHmOOtBq346to07qhG61ej3W
         lNaQ==
X-Gm-Message-State: AOAM532SLaWEkM4x8HERFVKa5UH81Jvwqhf9nCamnHPwvzlHV+qXy0cJ
	X2NNQJefgdpUzkTEgllxSccSoCJtSj6V1w48O6o=
X-Google-Smtp-Source: ABdhPJzBS/IU12Q2YLBhyoz+6vJfUVaXcX4FrEtco80BQRcU0QzLZowxG3h7R3bmgOXFDeycWurJBTy2GY7RgpuGUiE=
X-Received: by 2002:a92:874a:: with SMTP id d10mr40497264ilm.273.1596129286567;
 Thu, 30 Jul 2020 10:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <87k0ylgff0.fsf@oldenburg2.str.redhat.com> <CAG48ez3OF7DPupKv9mBBKmg-9hDVhVe83KrJ4Jk=CL0nOc7=Jg@mail.gmail.com>
 <87h7tpeyed.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87h7tpeyed.fsf@oldenburg2.str.redhat.com>
From: "H.J. Lu" <hjl.tools@gmail.com>
Date: Thu, 30 Jul 2020 10:14:10 -0700
Message-ID: <CAMe9rOqnPJMC+d9cRTc-zHaj7Pp5JvW-Zfqxhy3M3P6zG_CE0A@mail.gmail.com>
Subject: Re: Alternative CET ABI
To: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>, oss-security@lists.openwall.com, 
	x86-64-abi <x86-64-abi@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 30, 2020 at 9:54 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Jann Horn:
>
> > On Thu, Jul 30, 2020 at 6:02 PM Florian Weimer <fweimer@redhat.com> wrote:
> >> Functions no longer start with the ENDBR64 prefix.  Instead, the link
> >> editor produces a PLT entry with an ENDBR64 prefix if it detects any
> >> address-significant relocation for it.  The PLT entry performs a NOTRACK
> >> jump to the target address.  This assumes that the target address is
> >> subject to RELRO, of course, so that redirection is not possible.
> >> Without address-significant relocations, the link editor produces a PLT
> >> entry without the ENDBR64 prefix (but still with the NOTRACK jump), or
> >> perhaps no PLT entry at all.
> >
> > How would this interact with function pointer comparisons? As in, if
> > library A exports a function func1 without referencing it, and
> > libraries B and C both take references to func1, would they end up
> > with different function pointers (pointing to their respective PLT
> > entries)?
>
> Same as today.  ELF already deals with this by picking one canonical
> function address per process.
>
> Some targets already need PLTs for inter-DSO calls, so the problem is
> not new.  It happens even on x86 because the main program can refer to
> its PLT stubs without run-time relocations, so those determine the
> canonical address of those functions, and not the actual implementation
> in a shared object.
>
> > Would this mean that the behavior of a program that compares
> > function pointers obtained through different shared libraries might
> > change?
>
> Hopefully not, because that would break things quite horribly (as it's
> sometimes possible to observe if the RTLD_DEEPBIND flag is used).
>
> Both the canonicalization and the fact in order to observe the function
> pointer, you need to take its address should take care of this.
>
> > I guess you could maybe canonicalize function pointers somehow, but
> > that'd probably at least break dlclose(), right?
>
> Ahh, dlclose.  I think in this case, my idea to generate a PLT stub
> locally in the address-generating DSO will not work because the
> canonical address must survive dlclose if it refers to another DSO.
> There are two ways to deal with this: do not unload the PLT stub until
> the target DSO is also unloaded (but make sure that the DSO can be
> reloaded at a different address; probably not worth the complexity),
> or use the dlsym hack I sketched for regular symbol binding as well.
> Even more room for experiments, I guess.
>
> Thanks,
> Florian

FWIW, we can introduce a different CET PLT as long as it is compatible
with the past, current and future binaries.

-- 
H.J.
