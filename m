Return-Path: <kernel-hardening-return-21933-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id DADF1C0219B
	for <kernel-hardening@archiver.kernel.org>; Sun,  9 Feb 2025 18:02:55 +0000 (UTC)
Received: (qmail 9337 invoked by uid 550); 9 Feb 2025 18:02:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32048 invoked from network); 9 Feb 2025 06:24:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739082247; x=1739687047; darn=lists.openwall.com;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTto9Kr8hhs4LG0n8TSGyp+f3yaAmq1VIFKY3P9KHF0=;
        b=hnpHNds1yFQf6qM49rMEn3hvXP5g2rHUEiZcwV6caivpswl03X5PCfibfZNNssG5hi
         3IiAgmrqHzSU35OCje2t6Pzse8iTzPnQla8BM59NlCDbMINEsrv0798Isxl/d9SihlSZ
         faXWDL5phL7hWATQNtYypdiH1U30SFqihGP7mVjAgHbM+xNJHgNnUwYfDvQ5/g8mlHYU
         DgGw34D25M+0vJBd6RY9jLvenQCP5k+AzR3ph9d48MlYNQ7dwnzyJuq3NJ5KlVdv64TX
         sN6SbxjEK8CEfARM5Iax4DFAnCsfcKFkRZwAtayTd388rCqqrHEezkHw3t8XGL3/a9on
         m9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739082247; x=1739687047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yTto9Kr8hhs4LG0n8TSGyp+f3yaAmq1VIFKY3P9KHF0=;
        b=LC6iiZwclzCS9MrZs4zzR2WHSO8JOzKSp7SaNj3Ef7mpRjl/NKVgDrG4aCk1sRaWKL
         uwb+S3Klc187Odtdi0aj4Vh+UkiGqnNZhbtHmjDDNB83ff/zdPvk1y1FgfcXoqb6Fq6S
         OiLBEKlyfD2q1rUs9brtmAfXP2k5RpY1dYYBnTYGK+wBeG6b6kddvijT9Ty7mSDJDiXV
         DZEuTGRDX0M2CpHNKczYd7xafsaaesaaTMIudEZt5hzwcCj7tbD90B0i53p1rLwWuIZY
         AJ0JqAARlVHi+NAFZO1ELN2uBZjM9Tg8xND4iiRk/4SvsaoN+/GlzMYKgxKqdzuQSUZ6
         GTAA==
X-Forwarded-Encrypted: i=1; AJvYcCVqQ9wWR252H1rqyqlpJx5vD0d2EYAzbKtzu0jWxMkLxKViARVxaZqiGPTs6Tp+Aycab9K3GAjgF0rzCGioelF6@lists.openwall.com
X-Gm-Message-State: AOJu0Yw4s/SWpEut4mOK+b+uE8BunfB+kVLYymMK8tnBzWz7Mhkrm8+u
	YpuDeYKsAOl/NG4xxd7r3gsoguAAb7ejaGLIXknSUc3uccXSIhBEcIBtVWvOkoU=
X-Gm-Gg: ASbGncv/aUEEbsH5KdqICOaLxEucM4vCbGto5z+UW++Dxxvacc0An+gLN/Host1Cq6w
	FI+qxsWlDd8LZLsHMJO1WPPAs+c2NPs2LpqQjl/3rbBBCUfHlvrzOKujwIcVQmGQOpLOUNNBTnS
	UdiJWyqqz+l1hWB/iZ3DWoV/DOMHXGeHxt4k+u8t9eGtEkHvUWNjwSwmqQkRXh1rf4HjNf0bu5D
	03UC35bVxIQ5CJTw/kwwbdMD0wYjq8aYOp6/TJs0zQbi9TfDNzdXMVLgu5wXqxfpgeUEAHMfb5O
	AIP9iUX2bER0blz/LEMS
X-Google-Smtp-Source: AGHT+IES82N8C+fmH6KFZPQ2PcILhvhCYo68TATrCctmduAL8AzzSocttcg6O+pNFOFLcG4GQSgsDw==
X-Received: by 2002:a05:6402:4588:b0:5db:731d:4456 with SMTP id 4fb4d7f45d1cf-5de45085cc7mr10374231a12.28.1739082247149;
        Sat, 08 Feb 2025 22:24:07 -0800 (PST)
Date: Sun, 9 Feb 2025 09:24:03 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Ethan Carter Edwards <ethan@ethancedwards.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-hams@vger.kernel.org, pabeni@redhat.com,
	linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3] hamradio: baycom: replace strcpy() with strscpy()
Message-ID: <90cb9ac2-2af9-4fc7-b93d-0f36514a76f6@stanley.mountain>
References: <3qo3fbrak7undfgocsi2s74v4uyjbylpdqhie4dohfoh4welfn@joq7up65ug6v>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3qo3fbrak7undfgocsi2s74v4uyjbylpdqhie4dohfoh4welfn@joq7up65ug6v>

On Sat, Feb 08, 2025 at 11:06:21PM -0500, Ethan Carter Edwards wrote:
> The strcpy() function has been deprecated and replaced with strscpy().
> There is an effort to make this change treewide:
> https://github.com/KSPP/linux/issues/88.
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>
> Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  v3: resend after merge window ends
>  Link to v2: https://lore.kernel.org/lkml/62yrwnnvqtwv4etjeaatms5xwiixirkbm6f7urmijwp7kk7bio@r2ric7eqhsvf/T/#u
>  v2: reduce verbosity
>  Link to v1: https://lore.kernel.org/lkml/bqKL4XKDGLWNih2jsEzZYpBSHG6Ux5mLZfDBIgHckEUxDq4l4pPgQPEXEqKRE7pUwMrXZBVeko9aYr1w_E5h5r_R_YFA46G8dGhV1id7zy4=@ethancedwards.com/

Ah great.  Thanks for remembering.

regards,
dan carpenter

