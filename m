Return-Path: <kernel-hardening-return-21855-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2E0F2D68BC8
	for <kernel-hardening@archiver.kernel.org>; Fri, 15 Nov 2024 16:18:35 +0000 (UTC)
Received: (qmail 29965 invoked by uid 550); 15 Nov 2024 16:18:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29921 invoked from network); 15 Nov 2024 16:18:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731687490; x=1732292290; darn=lists.openwall.com;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VPRAwnJHM0yj/wQYaOzcRH9Aml3wNsDwQd5Odhgyr5E=;
        b=E8CIXZjmTD9CYB3uzayiv2UCeCQOmPqfSlXbJHhKreVGg4QYHDmNGuWViwr5ho8lW3
         Nmpn8IQcvLGBF8zv1Vr2tYBsdEY/RTkIgPDtpBfJZNHXzgUgFQ9MUvply5Pv36Lls3Ae
         i79YIdGJjamHJ1uk6MppE9ROUefnsEQ9Hvz/3tOR9DbjBvu7Lfh9lxX5eR6RpO5Sqs6G
         tDEw/sMNGtcTKbb1tNe1ruwwa0QXEyQsI/v3qK1GNA+9iT8lSXWj7ocZXKZWNqLlU8vB
         JKs/YXCrboxeWC7IP3+Pgy2ZTBgkDNd5CU1qfTAKgfEBrJ/6yxVi/HCsIuV6HhwtA8rz
         bVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731687490; x=1732292290;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VPRAwnJHM0yj/wQYaOzcRH9Aml3wNsDwQd5Odhgyr5E=;
        b=OuUGOLz8KWnxYWQaw9Wc5iTORyFix1u0pFZ+tpju9FyJEyKzXECjNrMJ56shQnuJvd
         EI2UywFnu2U9QaabXj9h5VjOKuI7yZqhvyNmhbn8K5PNcew8Ol3mOx0lxy+WIPAZdo45
         BSu2d/TSapGwm/ijWm4H5Pluo0PO2BwJM0UwwHAVxWOF3osYkbEEo7r8PodKwhqiLaEf
         uwelrubABRdeGTxj4Wfvt7odm74mjN5t061bwFxrFp20Q/Hhkqv53ycxenrMnnwX9pD9
         zjxir7M4iNd9HHfC87uhHX3U0zHNOMESXkEfgNIm4vtqFF5ypZSjVJT8LuwjcL2FBE+m
         qYww==
X-Gm-Message-State: AOJu0YzhFsTnULuYO9u/DOajidaQhrzz3iHvjPrUrM+V21fwNQrcBDLP
	bN1JyYG4C0M8yec+8SA8Nk/MrsX6Zk6+7oAPyDaPT34zVu5UHUYmoRaOTtr8B/RhnhOC/E7cIqI
	yVgmViVSmcGUt6rQd4StfI8qULNg0oXEt
X-Google-Smtp-Source: AGHT+IE9+YBPtz90EA5vahfB4doZw05tN4zdOuX4MjcdEQsaAEpBNOp3vCbB76uabHJLVwdiceHO647zyF3zr9G7jSA=
X-Received: by 2002:a05:6870:1cb:b0:294:cac8:c788 with SMTP id
 586e51a60fabf-29606a062fdmr5454685fac.6.1731687490275; Fri, 15 Nov 2024
 08:18:10 -0800 (PST)
MIME-Version: 1.0
From: Muni Sekhar <munisekharrms@gmail.com>
Date: Fri, 15 Nov 2024 21:47:59 +0530
Message-ID: <CAHhAz+i+4iCn+Ddh1YvuMn1v-PfJj72m6DcjRaY+3vx7wLhFsQ@mail.gmail.com>
Subject: Help Needed: Debugging Memory Corruption results GPF
To: kernel-hardening@lists.openwall.com, 
	kasan-dev <kasan-dev@googlegroups.com>, LKML <linux-kernel@vger.kernel.org>, 
	kernelnewbies <kernelnewbies@kernelnewbies.org>
Content-Type: text/plain; charset="UTF-8"

Hi all,

I am encountering a memory corruption issue in the function
msm_set_laddr() from the Slimbus MSM Controller driver source code.
https://android.googlesource.com/kernel/msm/+/refs/heads/android-msm-sunfish-4.14-android12/drivers/slimbus/slim-msm-ctrl.c

In msm_set_laddr(), one of the arguments is ea (enumeration address),
which is a pointer to constant data. While testing, I observed strange
behavior:

The contents of the ea buffer get corrupted during a timeout scenario
in the call to:

timeout = wait_for_completion_timeout(&done, HZ);

Specifically, the ea buffer's contents differ before and after the
wait_for_completion_timeout() call, even though it's declared as a
pointer to constant data (const u8 *ea).
To debug this issue, I enabled KASAN, but it didn't reveal any memory
corruption. After the buffer corruption, random memory allocations in
other parts of the kernel occasionally result in a GPF crash.

Here is the relevant part of the code:

static int msm_set_laddr(struct slim_controller *ctrl, const u8 *ea,
                         u8 elen, u8 laddr)
{
    struct msm_slim_ctrl *dev = slim_get_ctrldata(ctrl);
    struct completion done;
    int timeout, ret, retries = 0;
    u32 *buf;
retry_laddr:
    init_completion(&done);
    mutex_lock(&dev->tx_lock);
    buf = msm_get_msg_buf(dev, 9, &done);
    if (buf == NULL)
        return -ENOMEM;
    buf[0] = SLIM_MSG_ASM_FIRST_WORD(9, SLIM_MSG_MT_CORE,
                                     SLIM_MSG_MC_ASSIGN_LOGICAL_ADDRESS,
                                     SLIM_MSG_DEST_LOGICALADDR,
                                     ea[5] | ea[4] << 8);
    buf[1] = ea[3] | (ea[2] << 8) | (ea[1] << 16) | (ea[0] << 24);
    buf[2] = laddr;
    ret = msm_send_msg_buf(dev, buf, 9, MGR_TX_MSG);
    timeout = wait_for_completion_timeout(&done, HZ);
    if (!timeout)
        dev->err = -ETIMEDOUT;
    if (dev->err) {
        ret = dev->err;
        dev->err = 0;
    }
    mutex_unlock(&dev->tx_lock);
    if (ret) {
        pr_err("set LADDR:0x%x failed:ret:%d, retrying", laddr, ret);
        if (retries < INIT_MX_RETRIES) {
            msm_slim_wait_retry(dev);
            retries++;
            goto retry_laddr;
        } else {
            pr_err("set LADDR failed after retrying:ret:%d", ret);
        }
    }
    return ret;
}

What I've Tried:
KASAN: Enabled it but couldn't identify the source of the corruption.
Debugging Logs: Added logs to print the ea contents before and after
the wait_for_completion_timeout() call. The logs show a mismatch in
the data.

Question:
How can I efficiently trace the source of the memory corruption in
this scenario?
Could wait_for_completion_timeout() or a related function cause
unintended side effects?
Are there additional tools or techniques (e.g., dynamic debugging or
specific kernel config options) that can help identify this
corruption?
Any insights or suggestions would be greatly appreciated!



-- 
Thanks,
Sekhar
