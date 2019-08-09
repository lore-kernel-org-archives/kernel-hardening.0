Return-Path: <SRS0=Lm7g=WF=lists.openwall.com=kernel-hardening-return-16774-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 040B3C31E40
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:37:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 334A7217F5
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Aug 2019 13:37:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 334A7217F5
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16774-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4047 invoked by uid 550); 9 Aug 2019 13:37:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4015 invoked from network); 9 Aug 2019 13:37:06 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:openpgp
         :autocrypt:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=W/e3FaKnyiiHnPYNMIM+3ocFb3MozK25GrlOTfW37lE=;
        b=gDeHt1p9LQz2/lbU7Ozq4egVSgLzrbzvAOADyrsIHsfEaazYerTu+kJ35GxAQA/ouS
         OZN6I3DxuqtPmINLJtyna4nuDV5VLGcsLKkLOb6xV3+8Fr9UsIgUu1olWG8PJN40+kz3
         suYW5GUK7LfhhdMPuPgyfjGqZT4iuSo5HLnCgIhxRVjdoIonrVWfmBX75ERGEiMgxg0n
         M7DWKcMLuvAvUIGZiDPZMXXoXPD+HC3EpYVkuo9/U4cr5qOO9s3h4gPxDSUXLHAsn1BF
         4b3WYcd9Ec4PeicGqAJ4i/OsZ4rcXMr/CMP1iDOOsCAvpxDvqSWFPPpBEsAzGE6JFtSL
         jldQ==
X-Gm-Message-State: APjAAAVL6DFFwPGZnaAX5Z8hdwB4oey7dMRhXNlLYQtM7KaFHdxtGre6
	0pr7zb8/7YK4a0hjfbzHfAtdzmTsKDI=
X-Google-Smtp-Source: APXvYqy8kM4WZJhFhhgNKZ0v33EjUbjFKiHw3L61zhVj+IgMT7WanUaTrOMeuGJ3cvIngDqLgpP8wQ==
X-Received: by 2002:a19:a419:: with SMTP id q25mr13024216lfc.136.1565357815476;
        Fri, 09 Aug 2019 06:36:55 -0700 (PDT)
Subject: Re: [PATCH] floppy: fix usercopy direction
To: Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: Jiri Kosina <jikos@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
 Mukesh Ojha <mojha@codeaurora.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 Denis Efremov <efremov@linux.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
 Gilles Muller <Gilles.Muller@lip6.fr>, Nicolas Palix
 <nicolas.palix@imag.fr>, Michal Marek <michal.lkml@markovi.net>,
 cocci@systeme.lip6.fr
References: <20190326220348.61172-1-jannh@google.com>
From: Alexander Popov <alex.popov@linux.com>
Openpgp: preference=signencrypt
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 mQINBFX15q4BEADZartsIW3sQ9R+9TOuCFRIW+RDCoBWNHhqDLu+Tzf2mZevVSF0D5AMJW4f
 UB1QigxOuGIeSngfmgLspdYe2Kl8+P8qyfrnBcS4hLFyLGjaP7UVGtpUl7CUxz2Hct3yhsPz
 ID/rnCSd0Q+3thrJTq44b2kIKqM1swt/F2Er5Bl0B4o5WKx4J9k6Dz7bAMjKD8pHZJnScoP4
 dzKPhrytN/iWM01eRZRc1TcIdVsRZC3hcVE6OtFoamaYmePDwWTRhmDtWYngbRDVGe3Tl8bT
 7BYN7gv7Ikt7Nq2T2TOfXEQqr9CtidxBNsqFEaajbFvpLDpUPw692+4lUbQ7FL0B1WYLvWkG
 cVysClEyX3VBSMzIG5eTF0Dng9RqItUxpbD317ihKqYL95jk6eK6XyI8wVOCEa1V3MhtvzUo
 WGZVkwm9eMVZ05GbhzmT7KHBEBbCkihS+TpVxOgzvuV+heCEaaxIDWY/k8u4tgbrVVk+tIVG
 99v1//kNLqd5KuwY1Y2/h2MhRrfxqGz+l/f/qghKh+1iptm6McN//1nNaIbzXQ2Ej34jeWDa
 xAN1C1OANOyV7mYuYPNDl5c9QrbcNGg3D6gOeGeGiMn11NjbjHae3ipH8MkX7/k8pH5q4Lhh
 Ra0vtJspeg77CS4b7+WC5jlK3UAKoUja3kGgkCrnfNkvKjrkEwARAQABtCZBbGV4YW5kZXIg
 UG9wb3YgPGFsZXgucG9wb3ZAbGludXguY29tPokCQAQTAQoAKgIbIwIeAQIXgAULCQgHAwUV
 CgkICwUWAgMBAAUJB8+UXAUCWgsUegIZAQAKCRCODp3rvH6PqqpOEACX+tXHOgMJ6fGxaNJZ
 HkKRFR/9AGP1bxp5QS528Sd6w17bMMQ87V5NSFUsTMPMcbIoO73DganKQ3nN6tW0ZvDTKpRt
 pBUCUP8KPqNvoSs3kkskaQgNQ3FXv46YqPZ7DoYj9HevY9NUyGLwCTEWD2ER5zKuNbI2ek82
 j4rwdqXn9kqqBf1ExAoEsszeNHzTKRl2d+bXuGDcOdpnOi7avoQfwi/O0oapR+goxz49Oeov
 YFf1EVaogHjDBREaqiqJ0MSKexfVBt8RD9ev9SGSIMcwfhgUHhMTX2JY/+6BXnUbzVcHD6HR
 EgqVGn/0RXfJIYmFsjH0Z6cHy34Vn+aqcGa8faztPnmkA/vNfhw8k5fEE7VlBqdEY8YeOiza
 hHdpaUi4GofNy/GoHIqpz16UulMjGB5SBzgsYKgCO+faNBrCcBrscWTl1aJfSNJvImuS1JhB
 EQnl/MIegxyBBRsH68x5BCffERo4FjaG0NDCmZLjXPOgMvl3vRywHLdDZThjAea3pwdGUq+W
 C77i7tnnUqgK7P9i+nEKwNWZfLpfjYgH5JE/jOgMf4tpHvO6fu4AnOffdz3kOxDyi+zFLVcz
 rTP5b46aVjI7D0dIDTIaCKUT+PfsLnJmP18x7dU/gR/XDcUaSEbWU3D9u61AvxP47g7tN5+a
 5pFIJhJ44JLk6I5H/bkCDQRV9eauARAArcUVf6RdT14hkm0zT5TPc/3BJc6PyAghV/iCoPm8
 kbzjKBIK80NvGodDeUV0MnQbX40jjFdSI0m96HNt86FtifQ3nwuW/BtS8dk8+lakRVwuTgMb
 hJWmXqKMFdVRCbjdyLbZWpdPip0WGND6p5i801xgPRmI8P6e5e4jBO4Cx1ToIFyJOzD/jvtb
 UhH9t5/naKUGa5BD9gSkguooXVOFvPdvKQKca19S7bb9hzjySh63H4qlbhUrG/7JGhX+Lr3g
 DwuAGrrFIV0FaVyIPGZ8U2fjLKpcBC7/lZJv0jRFpZ9CjHefILxt7NGxPB9hk2iDt2tE6jSl
 GNeloDYJUVItFmG+/giza2KrXmDEFKl+/mwfjRI/+PHR8PscWiB7S1zhsVus3DxhbM2mAK4x
 mmH4k0wNfgClh0Srw9zCU2CKJ6YcuRLi/RAAiyoxBb9wnSuQS5KkxoT32LRNwfyMdwlEtQGp
 WtC/vBI13XJVabx0Oalx7NtvRCcX1FX9rnKVjSFHX5YJ48heAd0dwRVmzOGL/EGywb1b9Q3O
 IWe9EFF8tmWV/JHs2thMz492qTHA5pm5JUsHQuZGBhBU+GqdOkdkFvujcNu4w7WyuEITBFAh
 5qDiGkvY9FU1OH0fWQqVU/5LHNizzIYN2KjU6529b0VTVGb4e/M0HglwtlWpkpfQzHMAEQEA
 AYkCJQQYAQIADwUCVfXmrgIbDAUJCWYBgAAKCRCODp3rvH6PqrZtEACKsd/UUtpKmy4mrZwl
 053nWp7+WCE+S9ke7CFytmXoMWf1CIrcQTk5cmdBmB4E0l3sr/DgKlJ8UrHTdRLcZZnbVqur
 +fnmVeQy9lqGkaIZvx/iXVYUqhT3+DNj9Zkjrynbe5pLsrGyxYWfsPRVL6J4mQatChadjuLw
 7/WC6PBmWkRA2SxUVpxFEZlirpbboYWLSXk9I3JmS5/iJ+P5kHYiB0YqYkd1twFXXxixv1GB
 Zi/idvWTK7x6/bUh0AAGTKc5zFhyR4DJRGROGlFTAYM3WDoa9XbrHXsggJDLNoPZJTj9DMww
 u28SzHLvR3t2pY1dT61jzKNDLoE3pjvzgLKF/Olif0t7+m0IPKY+8umZvUEhJ9CAUcoFPCfG
 tEbL6t1xrcsT7dsUhZpkIX0Qc77op8GHlfNd/N6wZUt19Vn9G8B6xrH+dinc0ylUc4+4yxt6
 6BsiEzma6Ah5jexChYIwaB5Oi21yjc6bBb4l6z01WWJQ052OGaOBzi+tS5iGmc5DWH4/pFqX
 OIkgJVVgjPv2y41qV66QJJEi2wT4WUKLY1zA9s6KXbt8dVSzJsNFvsrAoFdtzc8v6uqCo0/W
 f0Id8MBKoqN5FniTHWNxYX6b2dFwq8i5Rh6Oxc6q75Kg8279+co3/tLCkU6pGga28K7tUP2z
 h9AUWENlnWJX/YhP8IkCJQQYAQoADwIbDAUCWgsSOgUJB9eShwAKCRCODp3rvH6PqtoND/41
 ozCKAS4WWBBCU6AYLm2SoJ0EGhg1kIf9VMiqy5PKlSrAnW5yl4WJQcv5wER/7EzvZ49Gj8aG
 uRWfz3lyQU8dH2KG6KLilDFCZF0mViEo2C7O4QUx5xmbpMUq41fWjY947Xvd3QDisc1T1/7G
 uNBAALEZdqzwnKsT9G27e9Cd3AW3KsLAD4MhsALFARg6OuuwDCbLl6k5fu++26PEqORGtpJQ
 rRBWan9ZWb/Y57P126IVIylWiH6vt6iEPlaEHBU8H9+Z0WF6wJ5rNz9gR6GhZhmo1qsyNedD
 1HzOsXQhvCinsErpZs99VdZSF3d54dac8ypH4hvbjSmXZjY3Sblhyc6RLYlru5UXJFh7Hy+E
 TMuCg3hIVbdyFSDkvxVlvhHgUSf8+Uk3Ya4MO4a5l9ElUqxpSqYH7CvuwkG+mH5mN8tK3CCd
 +aKPCxUFfil62DfTa7YgLovr7sHQB+VMQkNDPXleC+amNqJb423L8M2sfCi9gw/lA1ha6q80
 ydgbcFEkNjqz4OtbrSwEHMy/ADsUWksYuzVbw7/pQTc6OAskESBr5igP7B/rIACUgiIjdOVB
 ktD1IQcezrDcuzVCIpuq8zC6LwLm7V1Tr6zfU9FWwnqzoQeQZH4QlP7MBuOeswCpxIl07mz9
 jXz/74kjFsyRgZA+d6a1pGtOwITEBxtxxg==
Message-ID: <9ced7a06-5048-ad1a-3428-c8f943f7469c@linux.com>
Date: Fri, 9 Aug 2019 16:36:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190326220348.61172-1-jannh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hello everyone!

On 27.03.2019 1:03, Jann Horn wrote:
> As sparse points out, these two copy_from_user() should actually be
> copy_to_user().

I've spent some time on these bugs, but it turned out that they are already public.

I think Jann's patch is lost, it is not applied to the mainline.
So I add a new floppy maintainer Denis Efremov to CC.

These bugs on x86_64 cause memset for the userspace memory from the kernelspace.
That is funny:
 - access_ok for the copy_from_user source (2nd argument) returns zero;
 - copy_from_user tries to erase the destination (1st argument);
 - but the destination is in the userspace instead of kernelspace.

So we have:
[   40.937098] BUG: unable to handle page fault for address: 0000000041414242
[   40.938714] #PF: supervisor write access in kernel mode
[   40.939951] #PF: error_code(0x0002) - not-present page
[   40.941121] PGD 7963f067 P4D 7963f067 PUD 0
[   40.942107] Oops: 0002 [#1] SMP NOPTI
[   40.942968] CPU: 0 PID: 292 Comm: d Not tainted 5.3.0-rc3+ #7
[   40.944288] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
[   40.946478] RIP: 0010:__memset+0x24/0x30
[   40.947394] Code: 90 90 90 90 90 90 0f 1f 44 00 00 49 89 f9 48 89 d1 83 e2 07
48 c1 e9 03 40 0f b6 f6 48 b8 01 01 01 01 01 01 01 01 48 0f af c6 <f3> 48 ab 89
d1 f3 aa 4c 89 c8 c3 90 49 89 f9 40 88 f0 48 89 d1 f3
[   40.951721] RSP: 0018:ffffc900003dbd58 EFLAGS: 00010206
[   40.952941] RAX: 0000000000000000 RBX: 0000000000000034 RCX: 0000000000000006
[   40.954592] RDX: 0000000000000004 RSI: 0000000000000000 RDI: 0000000041414242
[   40.956169] RBP: 0000000041414242 R08: ffffffff8200bd80 R09: 0000000041414242
[   40.957753] R10: 0000000000121806 R11: ffff88807da28ab0 R12: ffffc900003dbd7c
[   40.959407] R13: 0000000000000001 R14: 0000000041414242 R15: 0000000041414242
[   40.961062] FS:  00007f91115c4440(0000) GS:ffff88807da00000(0000)
knlGS:0000000000000000
[   40.962603] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   40.963695] CR2: 0000000041414242 CR3: 000000007c584000 CR4: 00000000000006f0
[   40.965004] Call Trace:
[   40.965459]  _copy_from_user+0x51/0x60
[   40.966141]  compat_getdrvstat+0x124/0x170
[   40.966781]  fd_compat_ioctl+0x69c/0x6d0
[   40.967423]  ? selinux_file_ioctl+0x16f/0x210
[   40.968117]  compat_blkdev_ioctl+0x21d/0x8f0
[   40.968864]  __x32_compat_sys_ioctl+0x99/0x250
[   40.969659]  do_syscall_64+0x4a/0x110
[   40.970337]  entry_SYSCALL_64_after_hwframe+0x44/0xa9


I haven't found a way to exploit it.

> Fixes: 229b53c9bf4e ("take floppy compat ioctls to sodding floppy.c")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jann Horn <jannh@google.com>
> Reviewed-by: Mukesh Ojha <mojha@codeaurora.org>
> ---
> compile-tested only

Acked-by: Alexander Popov <alex.popov@linux.com>

>  drivers/block/floppy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index 95f608d1a098..8c641245ff12 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -3749,7 +3749,7 @@ static int compat_getdrvprm(int drive,
>  	v.native_format = UDP->native_format;
>  	mutex_unlock(&floppy_mutex);
>  
> -	if (copy_from_user(arg, &v, sizeof(struct compat_floppy_drive_params)))
> +	if (copy_to_user(arg, &v, sizeof(struct compat_floppy_drive_params)))
>  		return -EFAULT;
>  	return 0;
>  }
> @@ -3785,7 +3785,7 @@ static int compat_getdrvstat(int drive, bool poll,
>  	v.bufblocks = UDRS->bufblocks;
>  	mutex_unlock(&floppy_mutex);
>  
> -	if (copy_from_user(arg, &v, sizeof(struct compat_floppy_drive_struct)))
> +	if (copy_to_user(arg, &v, sizeof(struct compat_floppy_drive_struct)))
>  		return -EFAULT;
>  	return 0;
>  Eintr:
> 

I also wrote a coccinelle rule for detecting similar bugs (adding coccinelle
experts to CC).


virtual report

@cfu@
identifier f;
type t;
identifier v;
position decl_p;
position copy_p;
@@

f(..., t v@decl_p, ...)
{
<+...
copy_from_user@copy_p(v, ...)
...+>
}

@script:python@
f << cfu.f;
t << cfu.t;
v << cfu.v;
decl_p << cfu.decl_p;
copy_p << cfu.copy_p;
@@

if '__user' in t:
  msg0 = "function \"" + f + "\" has arg \"" + v + "\" of type \"" + t + "\""
  coccilib.report.print_report(decl_p[0], msg0)
  msg1 = "copy_from_user uses \"" + v + "\" as the destination. What a shame!\n"
  coccilib.report.print_report(copy_p[0], msg1)


The rule output:

./drivers/block/floppy.c:3756:49-52: function "compat_getdrvprm" has arg "arg"
of type "struct compat_floppy_drive_params __user *"
./drivers/block/floppy.c:3783:5-19: copy_from_user uses "arg" as the
destination. What a shame!

./drivers/block/floppy.c:3789:49-52: function "compat_getdrvstat" has arg "arg"
of type "struct compat_floppy_drive_struct __user *"
./drivers/block/floppy.c:3819:5-19: copy_from_user uses "arg" as the
destination. What a shame!


Best regards,
Alexander
