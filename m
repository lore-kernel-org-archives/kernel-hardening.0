Return-Path: <kernel-hardening-return-21666-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 48D02C77B7F
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 May 2023 15:17:25 +0000 (UTC)
Received: (qmail 11294 invoked by uid 550); 5 May 2023 15:17:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11274 invoked from network); 5 May 2023 15:17:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683299824;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=abj92oKBVKkSuSz9pqIREg9vXlBszotRotTWHKF/vxY=;
	b=TS1CC1sevwUhsdOm0jb6hmUcbpbPp7xnZnGvavuR03jOjJpeSSxedTgA9orb0akZmTnSYi
	iJR10J5wkJlAL18qcM8Qa8i3HGQITBaS+CKFb8mPs4/2yE36YUbsFyVxguZMOYG//C0Dut
	iQOzQ8JJ8LMyXDPHNC4UA9Jik7bfTLE=
X-MC-Unique: _HQDwx6EMyaeGfltl6NIGw-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299820; x=1685891820;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :from:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=abj92oKBVKkSuSz9pqIREg9vXlBszotRotTWHKF/vxY=;
        b=FfthqZIdjL9EZBxhhF6x1exckzxG2KzF1baG+86U6tM9ul/NhjDS9DG6cGSqbBmkoj
         sYohVZRKaX7+ZbDdkiMxVHrm57PBL/8G19Mppi8bZu+xdWc8Ztqbmt6lytdQp0OtXV4B
         fGhtfzeJ3071uWs3llVvhEjMbebI9OJvmW1dPLb8w6G0gw6jiaDioxJQXcFQVdIBalgt
         OTsH8vK4kyVUzVF9axm3wFISK07+Jxkj2TqN80UQLawKhKo13tL2klDBKuyRwUd7/yUe
         OfEG5ZAECkhVDgduUdWhk6rn3b23pT0AqXDSaeUB/BocspU7t2dqjRMzXKTzvJTDMZp3
         96Tg==
X-Gm-Message-State: AC+VfDw15HnCiFnYUxnVohkVexzUxe+PntKRsAoWexWLvRmna9oa2VFp
	rtpbGFsg5bFM/7nuJeOClBtWDzC3Z1zlRH3i6ZEX3tIfHyI1DDoGE6lBmywqRtb1hqVToB5kJVO
	FpqRpE4lAaakTk1bp9NNLTp/NOVDwJ7HCdQ==
X-Received: by 2002:a1c:7702:0:b0:3f1:72ec:4009 with SMTP id t2-20020a1c7702000000b003f172ec4009mr1676494wmi.9.1683299820163;
        Fri, 05 May 2023 08:17:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ78JBIXEOqF3dAix6y4QDwnEAMI8vIJEvszuxEpNDMp1Z2OwDOrdyWv9MUnAGy//RkyiltP9g==
X-Received: by 2002:a1c:7702:0:b0:3f1:72ec:4009 with SMTP id t2-20020a1c7702000000b003f172ec4009mr1676482wmi.9.1683299819807;
        Fri, 05 May 2023 08:16:59 -0700 (PDT)
Message-ID: <ac239fcf-9b2d-e82c-bec7-28d139384750@redhat.com>
Date: Fri, 5 May 2023 17:16:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
From: David Hildenbrand <david@redhat.com>
To: Sam James <sam@gentoo.org>
Cc: Michael McCracken <michael.mccracken@gmail.com>,
 linux-kernel@vger.kernel.org, serge@hallyn.com, tycho@tycho.pizza,
 Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>,
 Iurii Zaikin <yzaikin@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, kernel-hardening@lists.openwall.com
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com> <87pm7f9q3q.fsf@gentoo.org>
 <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com>
Organization: Red Hat
In-Reply-To: <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.05.23 17:15, David Hildenbrand wrote:
> On 05.05.23 09:46, Sam James wrote:
>>
>> David Hildenbrand <david@redhat.com> writes:
>>
>>> On 04.05.23 23:30, Michael McCracken wrote:
>>>> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
>>>> sysctl to 0444 to disallow all runtime changes. This will prevent
>>>> accidental changing of this value by a root service.
>>>> The config is disabled by default to avoid surprises.
>>>
>>> Can you elaborate why we care about "accidental changing of this value
>>> by a root service"?
>>>
>>> We cannot really stop root from doing a lot of stupid things (e.g.,
>>> erase the root fs), so why do we particularly care here?
>>
>> (I'm really not defending the utility of this, fwiw).
>>
>> In the past, I've seen fuzzing tools and other debuggers try to set
>> it, and it might be that an admin doesn't realise that. But they could
>> easily set other dangerous settings unsuitable for production, so...
> 
> At least fuzzing tools randomly toggling it could actually find real
> problems. Debugging tools ... makes sense that they might be using it.
> 
> What I understand is, that it's more of a problem that the system
> continues running and the disabled randomization isn't revealed to an
> admin easily.
> 
> If we really care, not sure what's better: maybe we want to disallow
> disabling it only in a security lockdown kernel? Or at least warn the
> user when disabling it? (WARN_TAINT?)

Sorry, not WARN_TAINT. pr_warn() maybe. Tainting the kernel is probably 
a bit too much as well.

-- 
Thanks,

David / dhildenb

