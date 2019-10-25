Return-Path: <SRS0=zaUH=YS=lists.openwall.com=kernel-hardening-return-17103-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1ABCA9EAF
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 02:11:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 89C8D21D71
	for <kernel-hardening@archiver.kernel.org>; Fri, 25 Oct 2019 02:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P3/3hM+3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89C8D21D71
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17103-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28317 invoked by uid 550); 25 Oct 2019 02:11:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28285 invoked from network); 25 Oct 2019 02:11:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=eMod+peVky1R2jV5YHW7OhCYYwyF8T+37oaZ+MrQTUY=;
        b=P3/3hM+3ftg3RiRAhxugOmc0kE4/F9JM+pZcDCsuW4Savw4ZtbsMvu/NE+zZ+1ecnt
         Ra6/F8v791JJd4U9S0+y2Zbjp1gL7Mka63tqqk2QL/VhVWRP/IzhMGiZFYXqCzl1bvmq
         I9QDKQ52KOmpv9J39bm2f3iTwe0Q3kJ9x5CilluPdSuO4yc8AD3XqCKX3Fx3j5nWCvNb
         hWatr0yQNUQyN9kNdSDvgkH9pIj7wNcazzhKRdeioM/S+AW9ltW/HHR7xM0PEHYJLWqu
         lcI3dd6bejngboNEJcmJ7+f25EsxrKGvzKNyc2W3N5AL0QHNZYyMANVbGSqpqaJSFej3
         4UbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eMod+peVky1R2jV5YHW7OhCYYwyF8T+37oaZ+MrQTUY=;
        b=pssogL4igQyQ7neh6bVwvQMGWUW4ocyqA+bO04neATi1zcE3wyTsTSgkyd2ImP5PF6
         jESclSDRhlqjuRmxrBkdVoXL2p481BQC4RDugDyWCat8Tc985dPLG5b98nYIhaTi0R49
         F+HIeVh9jOyWHSzggnf1baRhd3RCAcAud1P8MuabJ4CBGI2urHPW65Em1au1AiQSinSk
         OMhtMmYDywVXKkDcJj0YkhHIqvAq/lW7fOGmLpMidPuwd+iUTmZdL7KyIcYwk6FVRp/P
         dO3Gz9TJzK8OEuC/6TWAv9SEm4MhLnLAoGbSfP+U48bwqGgp18oHFU+ZsuQWaSssa0Bz
         s7rQ==
X-Gm-Message-State: APjAAAXH9pdL1TvCx+jK4Csy4N8LFfZi0JPttlmIxt+OffvNZnyytCWA
	cTMjGos9OaBBxXJtpxpksow9bFMEjm98Dz5T4zE=
X-Google-Smtp-Source: APXvYqxb04lwgHaNP4PtyPYo0TwM/Hc3BIVBzDsxWVeRBWCACACdiASFHowAT+O+mjHvrKNHVkEHomeEI6EJAjUEHrs=
X-Received: by 2002:aca:f543:: with SMTP id t64mr807023oih.89.1571969470743;
 Thu, 24 Oct 2019 19:11:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook> <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook> <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
 <201910100950.5179A62E2@keescook> <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>
 <201910101106.9ACB5DB@keescook> <CAHhAz+hw251beDeaWRFV7oShngSQ_KAACXAzb45EZRBdZ3kbSg@mail.gmail.com>
In-Reply-To: <CAHhAz+hw251beDeaWRFV7oShngSQ_KAACXAzb45EZRBdZ3kbSg@mail.gmail.com>
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Fri, 25 Oct 2019 07:40:58 +0530
Message-ID: <CAHhAz+g6RBPKfUMne6Me_ha3FwUWj6a_pA=dYshyjAtOuu+SfA@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2019 at 7:33 PM Muni Sekhar <munisekharrms@gmail.com> wrote=
:
>
> On Fri, Oct 11, 2019 at 12:01 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, Oct 10, 2019 at 10:45:21PM +0530, Muni Sekhar wrote:
> > > I'm using Ubuntu distro, ran "reboot" command but after reboot
> > > console-ramoops-0 is not present in /sys/fs/pstore
> >
> > Hmpf. Well, then, I guess your boot firmware is pretty aggressive about
> > wiping RAM across boots. :(

After UEFI boot mode set Now I see that ramoops is working fine.

To validate this, I simulated the crash using the following command.

# echo c > /proc/sysrq-trigger


Then my system got rebooted automatically. After reboot , initially no
files present in pstore.

$ ls -ltr /sys/fs/pstore/

total 0


$ sudo modprobe ramoops mem_size=3D1048576 ecc=3D1 mem_address=3D0x3ff00000
console_size=3D16384 ftrace_size=3D16384 pmsg_size=3D16384 record_size=3D32=
768
mem_type=3D1 dump_oops=3D1


After loading the ramoops module, I see it generates dmesg and console logs=
.

$ ls -ltr /sys/fs/pstore/

total 0

-r--r--r-- 1 root root 54522 Oct 24 13:27 dmesg-ramoops-0

-r--r--r-- 1 root root 54604 Oct 24 13:27 dmesg-ramoops-1

-r--r--r-- 1 root root  3641 Oct 24 13:30 console-ramoops-0


I repeated it for many times and verified that it works consistently.

I=E2=80=99ve a actual test case where my system gets frozen  so have no
software control. I executed this test case and as expected my system
has frozen and recovered it by powering it on(cold boot?) and then
loaded the ramoops but this time no files present in /sys/fs/pstore.

Any idea, why it works for =E2=80=98simulating the crash=E2=80=99 and not i=
n actual
hang scenario? The only difference is , In actual hang case it needs a
manual hard reboot.

If you restart a PC in cold(hard) boot, is it possible to see the RAM
memory(previous boot) still? I really I don=E2=80=99t know how it works.

So, is there a  way to automatically reboot the Linux system when it
freezes? I set =E2=80=9Ckernel.softlockup_panic =3D 1, kernel.unknown_nmi_p=
anic
=3D 1, kernel.softlockup_all_cpu_backtrace =3D 1, kernel.panic =3D 1,
kernel.panic_on_io_nmi =3D 1, kernel.panic_on_oops =3D 1,
kernel.panic_on_stackoverflow =3D 1, kernel.panic_on_unrecovered_nmi =3D
1=E2=80=9D, but it does not helped to reboot when it freezes.


> >
> > There was a patch set to store to disk, but I haven't seen a recent
> > version of it, if you want to go that route[1].
> >
> > -Kees
> >
> > [1] https://lore.kernel.org/lkml/1551922630-27548-1-git-send-email-liao=
weixiong@allwinnertech.com/
> Thanks I will check it out.
>
> While loading ramoops I see "persistent_ram: uncorrectable error in
> header", is this harmful?
>
> [  270.864969] ramoops: using module parameters
> [  270.866651] persistent_ram: uncorrectable error in header
> [  270.867252] persistent_ram: uncorrectable error in header
> [  270.867728] persistent_ram: uncorrectable error in header
> [  270.868067] persistent_ram: uncorrectable error in header
> [  270.868492] persistent_ram: uncorrectable error in header
> [  270.868839] persistent_ram: uncorrectable error in header
> [  270.869209] persistent_ram: uncorrectable error in header
> [  270.869681] persistent_ram: uncorrectable error in header
> [  270.870026] persistent_ram: uncorrectable error in header
> [  270.870430] persistent_ram: uncorrectable error in header
> [  270.870774] persistent_ram: uncorrectable error in header
> [  270.871110] persistent_ram: uncorrectable error in header
> [  270.871687] persistent_ram: uncorrectable error in header
> [  270.872055] persistent_ram: uncorrectable error in header
> [  270.872567] persistent_ram: uncorrectable error in header
> [  270.872910] persistent_ram: uncorrectable error in header
> [  270.873243] persistent_ram: uncorrectable error in header
> [  270.873592] persistent_ram: uncorrectable error in header
> [  270.873932] persistent_ram: uncorrectable error in header
> [  270.874267] persistent_ram: uncorrectable error in header
> [  270.874614] persistent_ram: uncorrectable error in header
> [  270.874958] persistent_ram: uncorrectable error in header
> [  270.875300] persistent_ram: uncorrectable error in header
> [  270.875686] persistent_ram: uncorrectable error in header
> [  270.876028] persistent_ram: uncorrectable error in header
> [  270.876462] persistent_ram: uncorrectable error in header
> [  270.876808] persistent_ram: uncorrectable error in header
> [  270.877144] persistent_ram: uncorrectable error in header
> [  270.877519] persistent_ram: uncorrectable error in header
> [  270.877860] persistent_ram: uncorrectable error in header
> [  270.878199] persistent_ram: uncorrectable error in header
> [  270.878565] persistent_ram: uncorrectable error in header
> [  270.878916] persistent_ram: uncorrectable error in header
> [  270.881129] console [pstore-1] enabled
> [  270.884817] pstore: Registered ramoops as persistent store backend
> [  270.885232] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0
>
> >
> > --
> > Kees Cook
>
>
>
> --
> Thanks,
> Sekhar



--=20
Thanks,
Sekhar
