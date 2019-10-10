Return-Path: <SRS0=XThU=YD=lists.openwall.com=kernel-hardening-return-17005-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCE40C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 18:04:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0EC9E214E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 18:04:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K4Cd9Oqy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0EC9E214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17005-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16017 invoked by uid 550); 10 Oct 2019 18:04:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1070 invoked from network); 10 Oct 2019 17:15:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=uv9CgUPvhJk0dcbuhrLy2b9Rsop6/0m1nLWusrohf/w=;
        b=K4Cd9OqyRTEH4Kz+wRYd5StF/1iV/gUu0sPCbxsk0jmBteywjhM5XXajTclzeLn6Uw
         RxJd5oarsSudX1UiUONjfKqvJ1wYHs68U3EVCkfD+MksQbEJYPR56LmhVOE6G6c8/Fjq
         /iYJBZ6xaVzXUoSfJvTZW0SGIpFVp8jcoM/KocS99ErL+ZHTBQipgwt1DoaniB4IhQS8
         PpB/L4rUVH+wA0PqIgS8BIGKgpXNwO+XK5IZTYuWdUDu97SKNlXkIw05+nEZ0gcJCMm2
         FdiuIG0SbpNPvwUH+BrfAhOVgXxHn7/W828nIZ4py7ZNyxyKaD8+TiUx+65zs/aLMVPb
         hKRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=uv9CgUPvhJk0dcbuhrLy2b9Rsop6/0m1nLWusrohf/w=;
        b=kjZ7jGAVgSqQzj9O42s3UTe/Vz6/95S4bzIFxVc+8twaL9oxfV+1ILksDFvbuvyZB3
         L3pwE6dWq7MkjYXU3KBNJve0Zm1ZQX3MoRcbbxdVFNWSlufDTDWGF5ciVhDyX1dZ0qiZ
         Xzl5Y/7rVKaiUr7Gxkk3nd4ZpsDqRBx5JoOmIG/pxSUB0QMA9kWf7tOf5U348VcbylMX
         pI6fmrh5ChO2+rdgHcGtRIxZuolc/to+eyP9rdIlU/AT6yiiPHYLzVobyxcENo8akrDC
         9qyLbnxtmEzbzOctFzNeA51tEpn5hDMj2lsXm1WXOnxxiyg1PP4Q86bfBy4kVl6jix1T
         1Pog==
X-Gm-Message-State: APjAAAVbfNBDtwoNN3K8QVkKJsjmAP14mIfKilJ+1AdHRMwMgE08Rb8A
	qSpg+U9iKMzlW4QSf8hgtHf2XafJX3KXUkIP4hY=
X-Google-Smtp-Source: APXvYqzzm314dySC7nYRU3WJyulzVdeL3jVZP547O2EbPF5+X27TTeIOdNJF0enQ4u89HcQDJT5Oe8A/O4cLVQ5isJk=
X-Received: by 2002:a05:6830:1685:: with SMTP id k5mr9275249otr.203.1570727733402;
 Thu, 10 Oct 2019 10:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook> <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook> <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
 <201910100950.5179A62E2@keescook>
In-Reply-To: <201910100950.5179A62E2@keescook>
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Thu, 10 Oct 2019 22:45:21 +0530
Message-ID: <CAHhAz+j9oaAY9_sn16J2c=U+iidZKu3mp0pRpPZAvu4dJPetkg@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2019 at 10:26 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 10, 2019 at 09:19:26PM +0530, Muni Sekhar wrote:
> > Later I booted with =E2=80=9Cmemmap=3D1M!1023M ramoops.mem_size=3D10485=
76
> > ramoops.ecc=3D1 ramoops.mem_address=3D0x3ff00000
> > ramoops.console_size=3D16384 ramoops.ftrace_size=3D16384
> > ramoops.pmsg_size=3D16384 ramoops.record_size=3D32768 ramoops.mem_type=
=3D1
> > ramoops.dump_oops=3D1=E2=80=9D
> >
> > After reboot, In dmesg I see the following lines:
> >
> > [    0.373084] pstore: Registered ramoops as persistent store backend
> > [    0.373266] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0
> >
> > # cat /proc/iomem | grep "System RAM"
> > 00001000-0009d7ff : System RAM
> > 00100000-1fffffff : System RAM
> > 20100000-3fefffff : System RAM
> > 3ff00000-3fffffff : Persistent RAM
> > 40000000-b937dfff : System RAM
> > b9ba6000-b9ba6fff : System RAM
> > b9be9000-b9d5dfff : System RAM
> > b9ffa000-b9ffffff : System RAM
> > 100000000-13fffffff : System RAM
> >
> > I noticed Persistent RAM, not Persistent Memory (legacy). What is the
> > difference between these two?
>
> I think this might just be a difference is kernel versions and the
> string reported here. As long as it's not "System RAM" it should be
> available for pstore.
>
> > I could not find any file in /sys/fs/pstore after warm boot. Even
> > tried to trigger the crash by running =E2=80=9Cecho c > /proc/sysrq-tri=
gger=E2=80=9D
> > and then rebooted  the system manually. After system boots up, I could
> > not find dmesg-ramoops-N file in /sys/fs/pstore, even I could not find
> > any file in /sys/fs/pstore directory.
> >
> > Am I missing anything?
>
> Silly question: has the pstore filesystem been mounted there?
Yes, pstore is mounted.
# mount | grep pstore
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)

>
> $ mount | grep pstore
> pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)
>
> If so, try a warm reboot and you should have at least the prior boot's
> console output in /sys/fs/pstore/console-ramoops-0
I'm using Ubuntu distro, ran "reboot" command but after reboot
console-ramoops-0 is not present in /sys/fs/pstore
>
> If you don't, I'm not sure what's happening. You may want to try a newer
> kernel (I see you've also go the old ramoops dmesg reporting about ecc.)
>
> Here's my dmesg...
>
> # dmesg | egrep -i 'pstore|ramoops'
> ...
> [    1.004376] ramoops: using module parameters
> [    1.010837] ramoops: uncorrectable error in header
> [    1.163014] printk: console [pstore-1] enabled
> [    1.164476] pstore: Registered ramoops as persistent store backend
> [    1.165028] ramoops: using 0x100000@0x440000000, ecc: 16
> [    4.610229] pstore: Using crash dump compression: deflate
>
Here is my dmesg:
# dmesg | egrep -i 'pstore|ramoops'
[    0.274931] ramoops: using module parameters
[    0.369885] console [pstore-1] enabled
[    0.372306] pstore: Registered ramoops as persistent store backend
[    0.372504] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0


> If a warm boot works and cold boot doesn't, then it looks like your
> hardware wipes enough of RAM (or loses refresh for long enough) that
> even the ECC can't repair it, in which case pstore isn't going to work.
> :(
>
> --
> Kees Cook



--=20
Thanks,
Sekhar
