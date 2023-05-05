Return-Path: <kernel-hardening-return-21665-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 00765C77B7F
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 May 2023 15:15:44 +0000 (UTC)
Received: (qmail 8045 invoked by uid 550); 5 May 2023 15:15:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8021 invoked from network); 5 May 2023 15:15:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683299719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kkrG6TrT6vUt7l/1yAEGc4UPeZE85BI5/e7CQ9gxkxM=;
	b=bPMVmpuW8pXu0KfXPhgVpE9pu6zWngKu5a5omHVvF6fPTLJ9TehIybYlw7iTiKUBExjUaO
	0oNP7x1GiHnn+gow4SlCvuPsTGoqokJoNrnuqnLnuRVMca+ngR2KjW6inUoAoLy7A4NpJu
	E2e9NCA2tF+89wENlv3QrQRMhOKrku4=
X-MC-Unique: 4TemCvZkMOykZVStgab_sA-1
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683299717; x=1685891717;
        h=content-transfer-encoding:in-reply-to:subject:organization:from
         :references:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkrG6TrT6vUt7l/1yAEGc4UPeZE85BI5/e7CQ9gxkxM=;
        b=WxnE7hFWp3d2CPeYUF8QkjrtJRLdTfrG3Tc8nPzQEWEJqjOA/x74Lwm0yROx4yCBEc
         eeGU9KrzLcf4DsBh47zIFgLmOUE3rp2XXgSiKQWHP6rRBIrl41GtdChxFSUdovSXRHrp
         KItZouq/z7oDblxIgMQSSnQUt3luOwNA39h8vjRcG+2twnakbty08F3MOQ7NrNfWg7Bn
         uu9ZCCOBTx1uCB+Kiubap6AIHSbAz2FNNgMip0stGbZPQDepa9O2q4uDBsMCdWvPKXwO
         tYj8j731QkyYCVzke9cFglLTK2YiK4DwFXQMLd++oMjWNotmzpcCaYSongwZ3fV8eLX/
         wZ/A==
X-Gm-Message-State: AC+VfDxitJ+kTMeA69s/lCV8Lae/Q0EHnEdxKX3j/MlXMmXF/G/A65ra
	yjsHik7F4O83yCl3t8tMWdQhHVEBqeoFkYHctDBHt7UKXNRNaqRvNIeUgbcyDTo27RjYQAkjBIU
	yVQgZru2tgajxG+nQMqEgctN4CZbV9cZDYw==
X-Received: by 2002:adf:e852:0:b0:2f2:783f:ae4a with SMTP id d18-20020adfe852000000b002f2783fae4amr1565321wrn.32.1683299717085;
        Fri, 05 May 2023 08:15:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5JphXg6YSvIF6EBsByLfX+Q1TzMx3ezx0pIYW00N+N1esYSq7PB5q/K6U1CiU7dEnLsZInQg==
X-Received: by 2002:adf:e852:0:b0:2f2:783f:ae4a with SMTP id d18-20020adfe852000000b002f2783fae4amr1565295wrn.32.1683299716737;
        Fri, 05 May 2023 08:15:16 -0700 (PDT)
Message-ID: <c50ac5e4-3f84-c52a-561d-de6530e617d7@redhat.com>
Date: Fri, 5 May 2023 17:15:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
To: Sam James <sam@gentoo.org>
Cc: Michael McCracken <michael.mccracken@gmail.com>,
 linux-kernel@vger.kernel.org, serge@hallyn.com, tycho@tycho.pizza,
 Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>,
 Iurii Zaikin <yzaikin@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, kernel-hardening@lists.openwall.com
References: <20230504213002.56803-1-michael.mccracken@gmail.com>
 <fbf37518-328d-c08c-7140-5d09d7a2674f@redhat.com> <87pm7f9q3q.fsf@gentoo.org>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH] sysctl: add config to make randomize_va_space RO
In-Reply-To: <87pm7f9q3q.fsf@gentoo.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05.05.23 09:46, Sam James wrote:
> 
> David Hildenbrand <david@redhat.com> writes:
> 
>> On 04.05.23 23:30, Michael McCracken wrote:
>>> Add config RO_RANDMAP_SYSCTL to set the mode of the randomize_va_space
>>> sysctl to 0444 to disallow all runtime changes. This will prevent
>>> accidental changing of this value by a root service.
>>> The config is disabled by default to avoid surprises.
>>
>> Can you elaborate why we care about "accidental changing of this value
>> by a root service"?
>>
>> We cannot really stop root from doing a lot of stupid things (e.g.,
>> erase the root fs), so why do we particularly care here?
> 
> (I'm really not defending the utility of this, fwiw).
> 
> In the past, I've seen fuzzing tools and other debuggers try to set
> it, and it might be that an admin doesn't realise that. But they could
> easily set other dangerous settings unsuitable for production, so...

At least fuzzing tools randomly toggling it could actually find real 
problems. Debugging tools ... makes sense that they might be using it.

What I understand is, that it's more of a problem that the system 
continues running and the disabled randomization isn't revealed to an 
admin easily.

If we really care, not sure what's better: maybe we want to disallow 
disabling it only in a security lockdown kernel? Or at least warn the 
user when disabling it? (WARN_TAINT?)

-- 
Thanks,

David / dhildenb

