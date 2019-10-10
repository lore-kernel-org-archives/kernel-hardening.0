Return-Path: <SRS0=fJXJ=YD=lists.openwall.com=kernel-hardening-return-17003-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 284DDC4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 16:57:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73437214E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Oct 2019 16:57:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UqLyrrTi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73437214E0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17003-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26462 invoked by uid 550); 10 Oct 2019 16:57:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26427 invoked from network); 10 Oct 2019 16:57:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=meb5QF8+CEzM/t14WJHHzOtCQtObEEsRhTqm2Y5r99g=;
        b=UqLyrrTi9ZNTqRxOCf0FYwbwHn1V5wPjrJDAmDlqpx6Wo2HBBTu4cDlwels7x8K42X
         L1787AfQ0DxtpwyZPsPlOkgOff0vjEKiGeftsiJKxPf5dafuwBEujFL6vysLa1tmgYj6
         EOg1iKXvCBrr/IucfshHJwFSIiGfCVMrQ7WDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=meb5QF8+CEzM/t14WJHHzOtCQtObEEsRhTqm2Y5r99g=;
        b=AmlU/zmYEUVKN4Gpd7dfSkPG7PcOk6CfkzbGiuFddjSn9+UdFsXwu2jIKI7dQwiyvc
         /ZpwQPxPhD5UOv0bJmmGx0if1+vLP6A/xa5QNuvYJp8j0iqDXl0P0v8AbElZfaboVwlf
         wLg8oSymgNlFjnxDcBYu75TGOVQdS/RV7f8+Mpbxra/7KA4hbixunVxexfA5fMhjwzWn
         QQgmxd9XMeY6oz8ubO6D895I2/ZzxZM7ldwphgTG884vGggOLvkXPMoxi3ml1G5qamBa
         +G+Utedf5RmWYaunJGGJ0+xW1r9ZKqvoLkN1SL3tydpGHUYRIt+xeDAZ2swcbH3YJOrj
         NL1g==
X-Gm-Message-State: APjAAAWdTaDGT0L0bh+8wvFSz+Uz9tM6au/XP2vxT/aT2awZFq/KKL3d
	4fNrVO7afFR8DIsOS4lbBDkedkNFlt4=
X-Google-Smtp-Source: APXvYqyGoKOf0cbDMnsi3pgxV8ArrdMnBHwoNa0DryS3j7gUvlNEFpCh4Ym1LT/2gTd60MjL0TN5UQ==
X-Received: by 2002:aa7:9842:: with SMTP id n2mr11654244pfq.258.1570726617219;
        Thu, 10 Oct 2019 09:56:57 -0700 (PDT)
Date: Thu, 10 Oct 2019 09:56:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Subject: Re: How to get the crash dump if system hangs?
Message-ID: <201910100950.5179A62E2@keescook>
References: <CAHhAz+htpQewAZcpGWD567KLksorc+arA3Mu=hkUX+y6567jGA@mail.gmail.com>
 <201909301645.5FA44A4@keescook>
 <CAHhAz+jyZmLBsFBxLG_XmZRBrprrxa49T+07NhcrsH4Yi6jp6A@mail.gmail.com>
 <201910031417.2AEEE7B@keescook>
 <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHhAz+iUOum7EV1g9W=vFHZ0kq9US7L4CJFX4=QbSExrgBX7yg@mail.gmail.com>

On Thu, Oct 10, 2019 at 09:19:26PM +0530, Muni Sekhar wrote:
> Later I booted with “memmap=1M!1023M ramoops.mem_size=1048576
> ramoops.ecc=1 ramoops.mem_address=0x3ff00000
> ramoops.console_size=16384 ramoops.ftrace_size=16384
> ramoops.pmsg_size=16384 ramoops.record_size=32768 ramoops.mem_type=1
> ramoops.dump_oops=1”
> 
> After reboot, In dmesg I see the following lines:
> 
> [    0.373084] pstore: Registered ramoops as persistent store backend
> [    0.373266] ramoops: attached 0x100000@0x3ff00000, ecc: 16/0
> 
> # cat /proc/iomem | grep "System RAM"
> 00001000-0009d7ff : System RAM
> 00100000-1fffffff : System RAM
> 20100000-3fefffff : System RAM
> 3ff00000-3fffffff : Persistent RAM
> 40000000-b937dfff : System RAM
> b9ba6000-b9ba6fff : System RAM
> b9be9000-b9d5dfff : System RAM
> b9ffa000-b9ffffff : System RAM
> 100000000-13fffffff : System RAM
> 
> I noticed Persistent RAM, not Persistent Memory (legacy). What is the
> difference between these two?

I think this might just be a difference is kernel versions and the
string reported here. As long as it's not "System RAM" it should be
available for pstore.

> I could not find any file in /sys/fs/pstore after warm boot. Even
> tried to trigger the crash by running “echo c > /proc/sysrq-trigger”
> and then rebooted  the system manually. After system boots up, I could
> not find dmesg-ramoops-N file in /sys/fs/pstore, even I could not find
> any file in /sys/fs/pstore directory.
> 
> Am I missing anything?

Silly question: has the pstore filesystem been mounted there?

$ mount | grep pstore
pstore on /sys/fs/pstore type pstore (rw,nosuid,nodev,noexec,relatime)

If so, try a warm reboot and you should have at least the prior boot's
console output in /sys/fs/pstore/console-ramoops-0

If you don't, I'm not sure what's happening. You may want to try a newer
kernel (I see you've also go the old ramoops dmesg reporting about ecc.)

Here's my dmesg...

# dmesg | egrep -i 'pstore|ramoops'
...
[    1.004376] ramoops: using module parameters
[    1.010837] ramoops: uncorrectable error in header
[    1.163014] printk: console [pstore-1] enabled
[    1.164476] pstore: Registered ramoops as persistent store backend
[    1.165028] ramoops: using 0x100000@0x440000000, ecc: 16
[    4.610229] pstore: Using crash dump compression: deflate

If a warm boot works and cold boot doesn't, then it looks like your
hardware wipes enough of RAM (or loses refresh for long enough) that
even the ECC can't repair it, in which case pstore isn't going to work.
:(

-- 
Kees Cook
