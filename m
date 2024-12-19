Return-Path: <kernel-hardening-return-21909-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A5FF8E77184
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Dec 2024 20:51:10 +0000 (UTC)
Received: (qmail 16197 invoked by uid 550); 19 Dec 2024 20:50:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3075 invoked from network); 19 Dec 2024 19:34:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734636838; x=1735241638; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OYhuc5inlS1Dh76N6qD39s8i3QHaByq1kbDQ2SVZ5CI=;
        b=kiUywuybpMvMcRUrERTGHUuuwUU9XIPy+a7FPHdJh/ovGSBdhF58g3LuYdYtyLOH+b
         RemPUeCLYie2o2AXiD4pOKaQqGWXXDGoq5cQ+kM4LN6z6SY83lCjJTDll53k7ltmhu43
         vnNV0Vag/5/8tzIq06HZZ6cZYtx/M1CrlgrwLauF1dI9Jy1zh5Ti/s+GVWXPaIXhfU6H
         ipb+mQUPp8qn2l+ImIlD6WQFJMwAtmW0w4DzaqLQ1mZZ/ZKRNSD9ozcY6bp1Pfc6Jp4X
         S7TL0vyLvwArvvQU6HWILJSjcGRJk0tm5+9G0sqeHKNth+0QfDjHLdI8DDBUxSgTyyzB
         dlPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734636838; x=1735241638;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OYhuc5inlS1Dh76N6qD39s8i3QHaByq1kbDQ2SVZ5CI=;
        b=nxmez9T3jhbRe2wJZ4CoA/iAfhNCMkMHejpKDG7X/lYjCvGRAEmiYR3o37M5hSUrLx
         uQ76G/JiqQFRue9YnbD8NRRKRSKhSHLF8WtpPjIfSWmqciUCfXjo/SLE1xuQeYiT4dMd
         Yd7cUwlV8bASVkahk6ZNDzDfcLaif1O89hxqDtwVIEOPmuOaHK5+N0cqpXpFXgmXSJ0t
         gPiznXTMqQHFBm59gp6a10E282QQZRWXv4nE1EykVhnxyP44y6JoZuc/xCGxYiMNaESK
         F8bsHqoTRHiuIKwGIgBxtIK46aq5p4topZM2r5uz2SnQH45OmysvI/tU4XyeV4dLsWnV
         OwRQ==
X-Gm-Message-State: AOJu0YzgeHnzm/UDnxf//LmsP0hpoYQ056COs0Ux6xYterGvHh+B7iwQ
	DZpVQMk0pvqE/1NF0ckxqLpr67M31p4aybm6ceaOs5m2RPHh7F7jiqqwLnNDqARRvzbr7eQ3juF
	1n0XFDo1XIIN6MOHx+zKquE4qWis=
X-Gm-Gg: ASbGncv50uiSbuOYiB/FZ6d/TsxzjOzBhqsE0kGht1uSQ22vgT9xEnAUg+mIAX7HJ+0
	JFnl7xBiY3RMuQ9XSsT9ksnSM0++iiCEEU3ua
X-Google-Smtp-Source: AGHT+IE7g5KXaGQQVWQ1sDutSz1fnHfu8jWgQcLxGlg8CHXvH2HRjvDqZWY9ec8kDEKS/fgyhvmv9AWiA7PO/IIUgWI=
X-Received: by 2002:a05:690c:9b0f:b0:6ef:90a7:16ce with SMTP id
 00721157ae682-6f3f544696cmr8221017b3.42.1734636837700; Thu, 19 Dec 2024
 11:33:57 -0800 (PST)
MIME-Version: 1.0
References: <CAHhAz+i+4iCn+Ddh1YvuMn1v-PfJj72m6DcjRaY+3vx7wLhFsQ@mail.gmail.com>
In-Reply-To: <CAHhAz+i+4iCn+Ddh1YvuMn1v-PfJj72m6DcjRaY+3vx7wLhFsQ@mail.gmail.com>
From: jim.cromie@gmail.com
Date: Thu, 19 Dec 2024 14:33:31 -0500
Message-ID: <CAJfuBxzRpKLqgSbjEvBJuOFdjb+nrF-REiBA0o1myZ++Z9bnDA@mail.gmail.com>
Subject: Re: Help Needed: Debugging Memory Corruption results GPF
To: Muni Sekhar <munisekharrms@gmail.com>
Cc: kernel-hardening@lists.openwall.com, 
	kasan-dev <kasan-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernelnewbies <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Can you run this in a KVM ?

My go-to is virtme-ng, where I can run my hacks on my laptop,
in its own VM - on a copy of my whole system.
with the tools I'm familiar with.

then you can attach gdb to the VM.

then Id try a watchpoint on the memory.


On Fri, Nov 15, 2024 at 11:19=E2=80=AFAM Muni Sekhar <munisekharrms@gmail.c=
om> wrote:
>
> Hi all,
>
> I am encountering a memory corruption issue in the function
> msm_set_laddr() from the Slimbus MSM Controller driver source code.
> https://android.googlesource.com/kernel/msm/+/refs/heads/android-msm-sunf=
ish-4.14-android12/drivers/slimbus/slim-msm-ctrl.c
>
> In msm_set_laddr(), one of the arguments is ea (enumeration address),
> which is a pointer to constant data. While testing, I observed strange
> behavior:
>
> The contents of the ea buffer get corrupted during a timeout scenario
> in the call to:
>
> timeout =3D wait_for_completion_timeout(&done, HZ);
>
> Specifically, the ea buffer's contents differ before and after the
> wait_for_completion_timeout() call, even though it's declared as a
> pointer to constant data (const u8 *ea).
> To debug this issue, I enabled KASAN, but it didn't reveal any memory
> corruption. After the buffer corruption, random memory allocations in
> other parts of the kernel occasionally result in a GPF crash.
>
> Here is the relevant part of the code:
>
> static int msm_set_laddr(struct slim_controller *ctrl, const u8 *ea,
>                          u8 elen, u8 laddr)
> {
>     struct msm_slim_ctrl *dev =3D slim_get_ctrldata(ctrl);
>     struct completion done;
>     int timeout, ret, retries =3D 0;
>     u32 *buf;
> retry_laddr:
>     init_completion(&done);
>     mutex_lock(&dev->tx_lock);
>     buf =3D msm_get_msg_buf(dev, 9, &done);
>     if (buf =3D=3D NULL)
>         return -ENOMEM;
>     buf[0] =3D SLIM_MSG_ASM_FIRST_WORD(9, SLIM_MSG_MT_CORE,
>                                      SLIM_MSG_MC_ASSIGN_LOGICAL_ADDRESS,
>                                      SLIM_MSG_DEST_LOGICALADDR,
>                                      ea[5] | ea[4] << 8);
>     buf[1] =3D ea[3] | (ea[2] << 8) | (ea[1] << 16) | (ea[0] << 24);
>     buf[2] =3D laddr;
>     ret =3D msm_send_msg_buf(dev, buf, 9, MGR_TX_MSG);
>     timeout =3D wait_for_completion_timeout(&done, HZ);
>     if (!timeout)
>         dev->err =3D -ETIMEDOUT;
>     if (dev->err) {
>         ret =3D dev->err;
>         dev->err =3D 0;
>     }
>     mutex_unlock(&dev->tx_lock);
>     if (ret) {
>         pr_err("set LADDR:0x%x failed:ret:%d, retrying", laddr, ret);
>         if (retries < INIT_MX_RETRIES) {
>             msm_slim_wait_retry(dev);
>             retries++;
>             goto retry_laddr;
>         } else {
>             pr_err("set LADDR failed after retrying:ret:%d", ret);
>         }
>     }
>     return ret;
> }
>
> What I've Tried:
> KASAN: Enabled it but couldn't identify the source of the corruption.
> Debugging Logs: Added logs to print the ea contents before and after
> the wait_for_completion_timeout() call. The logs show a mismatch in
> the data.
>
> Question:
> How can I efficiently trace the source of the memory corruption in
> this scenario?
> Could wait_for_completion_timeout() or a related function cause
> unintended side effects?
> Are there additional tools or techniques (e.g., dynamic debugging or
> specific kernel config options) that can help identify this
> corruption?
> Any insights or suggestions would be greatly appreciated!
>
>
>
> --
> Thanks,
> Sekhar
>
> _______________________________________________
> Kernelnewbies mailing list
> Kernelnewbies@kernelnewbies.org
> https://lists.kernelnewbies.org/mailman/listinfo/kernelnewbies
