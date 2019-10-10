Return-Path: <SRS0=WOrR=YD=lists.openwall.com=kernel-hardening-return-17002-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D55E5C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 16:04:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 298CF214E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 16:04:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KARs2yJN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 298CF214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17002-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9901 invoked by uid 550); 10 Oct 2019 16:04:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5936 invoked from network); 10 Oct 2019 15:49:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wd8sJscw2ist6z1L4+bCuAyRmAggWu84QckwhORpPRw=;
        b=KARs2yJNuXTdbQSIaQlUs6W/kvOaoDaYjAyP9xd6R1+qVDI93VeKyO5EwPZkUN4PY1
         XtQdAPWwtufCVw7OS1GtFTIR5Lr+oMSafXe5kew4JPECClhCNE++ZquNDGnAQUH3aXvv
         C3/yECLFfwfSYhevZ0sXgTBr1s/OyqDuTh/WBpuxRmflDjlOOTtD+d+AkHfVW34WkYnT
         LAs1YIlyfgvkI4PEE5AdBkxWjfLbTGCVl1n//HhFoaBC6l9HofszKVjUYHkbRjnNBZQM
         fR+0mZY3iE66CLOCxVDVJ70VexIrWopVqAbXl3OedUghiHH9MMx5k0mNyU0z+tIL8tu6
         rnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wd8sJscw2ist6z1L4+bCuAyRmAggWu84QckwhORpPRw=;
        b=aQGBGaPQkTp07bM3+S6yESbdSXS/XKGBVVn8WIelLo9yHqvuHbdV5WLVXmFCHJAzXG
         lEyLUKmC0DcsccaDXSQsJSV9xDTTuxZXxy+bymOAVbxIGjSvr78WAU/RYoGdCURtP5Tt
         ZYVtarEv6qxh1MMuMBdFrjQ9Rp/TAWpGOsQutazZOrb/CamMBLQAjJJARoZv81dhPc1P
         Yf6rykRXXUVBQLtL8tEAuJU21hON5/c+4aYYpG6ghMsvaNE8EXdGfGwR0ARFz81UPa9w
         /j8YXDtUnwVjvslS2Rmsx2MzhhqyYJsTQzXov5Mr9EIe1ewauJoRsdqu83ghycAclwNx
         CPPg==
X-Gm-Message-State: APjAAAXLWz1YNEHuY/QUqeOOVJh82MUznv0NRbtLYJiqO2p2JqUxvBA3
	Qqas3cuJU5puOmKURX5Gtq/595cJbh0fXC0MZK4=
X-Google-Smtp-Source: APXvYqy5ypaYoHzA/oBDVU70Y0q7cL3bk4ORFsdtpTLB13kpF2UyPluLZd0TbsdcFWFr6JWPlzg+cTfnSXkqxtneGZ8=
X-Received: by 2002:aca:dcd6:: with SMTP id t205mr8254771oig.128.1570722577693;
 Thu, 10 Oct 2019 08:49:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook> <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook>
In-Reply-To: <201910031417.2AEEE7B@keescook>
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Thu, 10 Oct 2019 21:19:26 +0530
Message-ID: <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
Subject: Re: How to get the crash dump if system hangs?
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 4, 2019 at 3:06 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Oct 03, 2019 at 10:18:48PM +0530, Muni Sekhar wrote:
> > Thanks a lot for letting me know about pstore, will try this option.
> > It will be helpful if you can share some pointers on 'how to enable
> > software ECC'?
>
> When I boot with pstore, I use a bunch of command line arguments to test
> all its feature:
>
> ramoops.mem_size=3D1048576
> ramoops.ecc=3D1
> ramoops.mem_address=3D0x440000000
> ramoops.console_size=3D16384
> ramoops.ftrace_size=3D16384
> ramoops.pmsg_size=3D16384
> ramoops.record_size=3D32768
>
> but I'm using pmem driver to reserve the 1MB of memory at 0x440000000.
>
> To do a RAM reservation on a regular system, you'll need to do something
> like boot with:
>
> memmap=3D1M!1023M
>
> which says, reserve 1MB of memory at the 1023M offset. So this depends
> on how much physical memory you have, etc, but you'll be able to see the
> reservation after booting in /proc/iomem. e.g. for me, before:
>
> ...
> 00100000-bffd9fff : System RAM
> ...
>
> with memmap:
>
> ...
> 00100000-3fefffff : System RAM
> 3ff00000-3fffffff : Persistent Memory (legacy)
> 40000000-bffd9fff : System RAM
> ...
>
> So in that example, the address you'd want is 0x3ff00000
>
> memmap=3D1M!1023M
> ramoops.mem_size=3D1048576
> ramoops.ecc=3D1
> ramoops.mem_address=3D0x3ff00000
> ramoops.console_size=3D16384
> ramoops.ftrace_size=3D16384
> ramoops.pmsg_size=3D16384
> ramoops.record_size=3D32768
>
> In dmesg you should see:
>
> [    0.868818] pstore: Registered ramoops as persistent store backend
> [    0.869713] ramoops: using 0x100000@0x3ff00000, ecc: 16
>
> And if that address lines up with the "Persistent Memory (legacy)" line
> in /proc/iomem you should be good to go.
>
> Just mount /sys/fs/pstore and see if the console dump updates between
> warm boots, then try some cold boots, see if the ECC works, etc.
>
> Good luck!
>
> --
> Kees Cook

Thanks for the answers.

My kernel is configured with following .config options:

CONFIG_EFI_VARS_PSTORE=3Dy
# CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE is not set
CONFIG_PSTORE=3Dy
CONFIG_PSTORE_CONSOLE=3Dy
CONFIG_PSTORE_PMSG=3Dy
# CONFIG_PSTORE_FTRACE is not set
CONFIG_PSTORE_RAM=3Dy

Before RAM reservation, I see the following in /proc/iomem :
# cat iomem | grep "System RAM"

00001000-0009d7ff : System RAM
00100000-1fffffff : System RAM
20100000-b937dfff : System RAM
b9ba6000-b9ba6fff : System RAM
b9be9000-b9d5dfff : System RAM
b9ffa000-b9ffffff : System RAM
100000000-13fffffff : System RAM

Later I booted with =E2=80=9Cmemmap=3D1M!1023M ramoops.mem_size=3D1048576
ramoops.ecc=3D1 ramoops.mem_address=3D0x3ff00000
ramoops.console_size=3D16384 ramoops.ftrace_size=3D16384
ramoops.pmsg_size=3D16384 ramoops.record_size=3D32768 ramoops.mem_type=3D1
ramoops.dump_oops=3D1=E2=80=9D

After reboot, In dmesg I see the following lines:

[    0.373084] pstore: Registered ramoops as persistent store backend
[    0.373266] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0

# cat /proc/iomem | grep "System RAM"
00001000-0009d7ff : System RAM
00100000-1fffffff : System RAM
20100000-3fefffff : System RAM
3ff00000-3fffffff : Persistent RAM
40000000-b937dfff : System RAM
b9ba6000-b9ba6fff : System RAM
b9be9000-b9d5dfff : System RAM
b9ffa000-b9ffffff : System RAM
100000000-13fffffff : System RAM

I noticed Persistent RAM, not Persistent Memory (legacy). What is the
difference between these two?

I could not find any file in /sys/fs/pstore after warm boot. Even
tried to trigger the crash by running =E2=80=9Cecho c > /proc/sysrq-trigger=
=E2=80=9D
and then rebooted  the system manually. After system boots up, I could
not find dmesg-ramoops-N file in /sys/fs/pstore, even I could not find
any file in /sys/fs/pstore directory.

Am I missing anything?

--=20
Thanks,
Sekhar
