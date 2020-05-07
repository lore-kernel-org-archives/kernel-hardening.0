Return-Path: <SRS0=SwcX=6V=lists.openwall.com=kernel-hardening-return-18736-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7CF0C38A24
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 10:18:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C94122073A
	for <kernel-hardening@archiver.kernel.org>; Thu,  7 May 2020 10:18:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HuBe5N6X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C94122073A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18736-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21831 invoked by uid 550); 7 May 2020 10:18:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7923 invoked from network); 7 May 2020 07:07:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=RQbMvC1ag/SPzt3A0iv4z8R55U/VKwxU9VmHI0/FJRU=;
        b=HuBe5N6XnGvBabUFlomvKFuULmswvV6IlY50t+tlQh3qqFeVo5mlJMIvc7M96A6QjC
         j3LZOLKTSOkTavRzmk9QLDOed90qTi8J5m3bCK/GvzbOX5+fQnqzZ2lrFFlL9zSBb7bK
         XAFcn2P2vqnrYdpevPVAct9mZB7yGVFNe7rfbteS1bSoApWNTeI58mDIb5AlotWlL2pa
         f6sensKTOJeJLEEFoM777CUpUg8U1KZPaHrhXNqS+3kVcZqWfT9/i1vrGvq/wP09QPjM
         JTwRcQ3BaHtmTWAgaJUkpGH6Yyk3vceaghoSvRuvmphb3vT0EJ+OnF4YC8Ni9cgd0/t6
         EkYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RQbMvC1ag/SPzt3A0iv4z8R55U/VKwxU9VmHI0/FJRU=;
        b=XeDM59NEl6Sac4uGOBQth7KB4EBxx5KHbfV6Fb3zUOkJILbSsGFaVbCaI10O5riRX6
         SwQniQPuiyRHXldg17nXR8gqKgcgikO9WlbwRQsHwsNZuTyu0ahEMjRITuWeu52CFDAp
         XT9UEX/6d8EQDCoAiGsQsaRSlWwslzPV2vj6bdprN+8uv9EiwQDOzSIQnGaIu+Wds2Jt
         84aDto7oAsDkCzXtkY1GQL08iQrGn7cwQvCg2iS8ToRRJx26f38AG4ne+0GwXG1k+oob
         zIqNMmxR33Kjz2/Bh+sC5lTPbxKeltXW1aY5LoUdX9jhtMxxxiUgkoYzy8mAzoHbriLY
         s8Ow==
X-Gm-Message-State: AGi0Pua4LLeXzIZswHdbKDZczI2hwrApwXoMB7nCJrxJ/As7gsIgOoCg
	oT5Okq28OsO0Z5hIN+4zgDaKpJrkWNi1SyP3A6w=
X-Google-Smtp-Source: APiQypL8AC7ZUZnP0qgOLELJh2mB0qf4DRtMwN4Iryo60fDs4rqEG8PDwXDJX033RYCz1rFZGBj6H05V6VK++Hv+CxM=
X-Received: by 2002:aa7:c2d2:: with SMTP id m18mr10709938edp.142.1588835249498;
 Thu, 07 May 2020 00:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2002041054320.12768@namei.org> <CALrft9_tam87oevNC6LDG_bZoH+BgfrD4Or3yQudDoVqTqBdvg@mail.gmail.com>
In-Reply-To: <CALrft9_tam87oevNC6LDG_bZoH+BgfrD4Or3yQudDoVqTqBdvg@mail.gmail.com>
From: Elena Reshetova <elena.reshetova@gmail.com>
Date: Thu, 7 May 2020 10:07:18 +0300
Message-ID: <CALrft98SzLkw3M0shurUsNxsNSuSR3qN236rX4mEvC8GsrnnWQ@mail.gmail.com>
Subject: [ANNOUNCE][CFP] Linux Security Summit Europe 2020
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lwn@lwn.net, fedora-selinux-list@redhat.com, 
	linux-crypto@vger.kernel.org, kernel-hardening@lists.openwall.com, 
	linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
	Audit-ML <linux-audit@redhat.com>, gentoo-hardened@gentoo.org, keyrings@linux-nfs.org, 
	tpmdd-devel@lists.sourceforge.net, 
	Linux Security Summit Program Committee <lss-pc@lists.linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
                   ANNOUNCEMENT AND CALL FOR PARTICIPATION

                        LINUX SECURITY SUMMIT EUROPE 2020

                                     29-30 OCTOBER
                                    DUBLIN, IRELAND
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D

DESCRIPTION

Linux Security Summit Europe (LSS-EU) is a technical forum for
collaboration between Linux developers, researchers, and end-users.  Its
primary aim is to foster community efforts in analyzing and solving Linux
security challenges.

 The program committee currently seeks proposals for:

   * Refereed Presentations:
     45 minutes in length.

   * Panel Discussion Topics:
     45 minutes in length.

   * Short Topics:
     30 minutes in total, including at least 10 minutes discussion.

   * Tutorials
     90 minutes in length.

Tutorial sessions should be focused on advanced Linux security defense
topics within areas such as the kernel, compiler, and security-related
libraries.  Priority will be given to tutorials created for this conference=
,
and those where the presenter a leading subject matter expert on the topic.

Topic areas include, but are not limited to:

   * Kernel self-protection
   * Access control
   * Cryptography and key management
   * Integrity policy and enforcement
   * Hardware Security
   * IoT and embedded security
   * Virtualization and containers
   * System-specific system hardening
   * Case studies
   * Security tools
   * Security UX
   * Emerging technologies, threats & techniques

  Proposals should be submitted via:

   https://events.linuxfoundation.org/linux-security-summit-europe/program/=
cfp/

DATES

  * CFP close:            July 31
  * CFP notifications:    August 10
  * Schedule announced:   September 1
  * Event:                October 29-30

COVID-19 SITUATION

Currently LSS-EU is planned as in-person event, however this would be
re-evaluated closer to the event itself and if the situation in Europe does
not permit such events, it would be switched to a virtual event, similarly
as this year=E2=80=99s LSS-NA.

WHO SHOULD ATTEND

We're seeking a diverse range of attendees and welcome participation by
people involved in Linux security development, operations, and research.

LSS-EU is a unique global event that provides the opportunity to present an=
d
discuss your work or research with key Linux security community members and
maintainers.  It=E2=80=99s also useful for those who wish to keep up with t=
he latest
in Linux security development and to provide input to the development
process.

WEB SITE

    https://events.linuxfoundation.org/linux-security-summit-europe/

TWITTER

  For event updates and announcements, follow:

    https://twitter.com/LinuxSecSummit

    #linuxsecuritysummit

PROGRAM COMMITTEE

  The program committee for LSS 2020 is:

    * James Morris, Microsoft
    * Serge Hallyn, Cisco
    * Paul Moore, Cisco
    * Stephen Smalley, NSA
    * Elena Reshetova, Intel
    * John Johansen, Canonical
    * Kees Cook, Google
    * Casey Schaufler, Intel
    * Mimi Zohar, IBM
    * David A. Wheeler, Institute for Defense Analyses

  The program committee may be contacted as a group via email:
    lss-pc () lists.linuxfoundation.org
