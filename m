Return-Path: <kernel-hardening-return-21663-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 2997BC77B7C
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 May 2023 07:36:28 +0000 (UTC)
Received: (qmail 23816 invoked by uid 550); 5 May 2023 07:36:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 23790 invoked from network); 5 May 2023 07:36:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683272166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1CDos4xXpfX0yUzIH2R6tkwubXHkIXYBoy2gEXH5JA=;
	b=cLu68bsMm2EkHeGubhHUCGYl5bPLnhh0O30Vnd4OWURFsbZ+i2mcAqHoS40EpgKQ93YyCo
	XJamv8ZV/1btxYzGpP0FHXRPmmqLoCQSCRXDRLnxOz4Rc4fy29dL8BSyb6RaZobwMgq8lf
	MdidvQ/7Wgv783xskSpHehuB4ZIxNo4=
X-MC-Unique: FnHx9RA5OpaNWWBhD-v6gw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683272161; x=1685864161;
        h=content-transfer-encoding:in-reply-to:organization:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1CDos4xXpfX0yUzIH2R6tkwubXHkIXYBoy2gEXH5JA=;
        b=d2aj/C5vqpjVxmhC1ivrbPE2CW7Eg1Vbz5BiQj5vTShEcThHN7keQz2hIKxiyXwmdT
         6H9Rd+j/okvGwjE3UKiDX0sa3zjJ4tt2B91lo18iHlRj+pYdrkqKJfZwiC8aSsDSkrLn
         wGUy0PHGCEKrGjwSYAZW957L62OtwjR3UXsIV/1fOUqijwN1vJBa+3uWQDFnvzruEn8j
         TIxwy0P5p7KrGQrCz7+oruKVI3SaCghX0swV3NiIGJMvDCUmMKRGHmD0ZgFHqof7IzWN
         5AoF9c1w3KuvEc4bc7nAcG3lgduQQr+KzD7V7AQY4Utaf1v4AH6AZVXGVxNc1fm+8pwz
         75xQ==
X-Gm-Message-State: AC+VfDytI9gFYs2t1WriiGmFKZDjaP5wjHIEEJBeviZhwcaN8D1pLbRX
	ccA3eRbO5NerRB9PZyq4K/WD52QUqluy7DBx0hc+DFEWW/BI1TuNHipxhH0mgLzfqr2Zc1U28uG
	G0vvDmOngGxKyK+nn3TeotnYKvhga6+2nEA==
X-Received: by 2002:a1c:f60a:0:b0:3f2:5920:e198 with SMTP id w10-20020a1cf60a000000b003f25920e198mr327461wmc.34.1683272161232;
        Fri, 05 May 2023 00:36:01 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5XUDdNnSt2o2Ebxjr2vrScxpisR6Dhq9Ysweo7VXotuNFB3rkH+IP2VGzq0fyN3ub0us6E+w==
X-Received: by 2002:a1c:f60a:0:b0:3f2:5920:e198 with SMTP id w10-20020a1cf60a000000b003f25920e198mr327446wmc.34.1683272160847;
        Fri, 05 May 2023 00:36:00 -0700 (PDT)
Message-ID: <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com>
Date: Fri, 5 May 2023 09:35:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
To: Michael McCracken <michael.mccracken@gmail.com>,
 linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, serge@hallyn.com, tycho@tycho.pizza,
 Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>,
 Iurii Zaikin <yzaikin@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20230504213002.56803-1-michael.mccracken@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04.05.23 23:30, Michael McCracken wrote:
> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
> sysctl to 0444 to disallow all runtime changes. This will prevent
> accidental changing of this value by a root service.
> 
> The config is disabled by default to avoid surprises.

Can you elaborate why we care about "accidental changing of this value 
by a root service"?

We cannot really stop root from doing a lot of stupid things (e.g., 
erase the root fs), so why do we particularly care here?

-- 
Thanks,

David / dhildenb

