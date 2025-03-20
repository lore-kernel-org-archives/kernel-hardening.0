Return-Path: <kernel-hardening-return-21951-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id B3346C28B30
	for <kernel-hardening@archiver.kernel.org>; Thu, 20 Mar 2025 18:48:13 +0000 (UTC)
Received: (qmail 30025 invoked by uid 550); 20 Mar 2025 18:45:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21620 invoked from network); 20 Mar 2025 14:34:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742481254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7iLhCsEgmriA0Arg3aT+EM1OvQ9q5N2Kzwt92zewZ6E=;
	b=XIxC3DceFhMsqAeI0vWNEeKYmDtwv9skHElnZp2ILeHWN84MB6MhzSV/6gjcSrkUZEh59N
	aVVEwOPm1ZUxmP7np8tjgXIoWmnthUBvLbwVz2UZHvxM36g3UwlF7d9Xr9tO/Yls3Thv0z
	v6zBHzSszdMCbihVOzxK5wg0i5UCpdw=
X-MC-Unique: nAWQX_4DMOaPICftSnj8jA-1
X-Mimecast-MFC-AGG-ID: nAWQX_4DMOaPICftSnj8jA_1742481250
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742481250; x=1743086050;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aLsT93dSweyrf+qk2uXM1EK4iaVizTPbN4c8paMt31M=;
        b=EUnRYgZv17aJP8rzyJUUWJLtjQZMAbTj9DiVAi2aL1GeV63u3V6z7v3dNAsOALPruW
         xEm/X9iOn2QPxAXH8SrCJvO6PzuAhCNnjmPFtGDDHX2ffaOncaEgdQScUBDmYXVowpla
         5nfZUE/QgNu4l0fu6hlygjzhoci00Ll4fo47y8lRn91urBkDtLPJu2geo81sVWc4A+RS
         HIEbHj86JmYmZG6tJqFFu8m+DPqUcyQSm2qosI/hBF7/linpcXbDtI0ePdvjx66skBcJ
         qPYNggwPX0Fyxi7yXPzt+5EJ0KY3yTwRpLmGCneDwU+BpwvC1BhBJyjz97t39XskAZNe
         MDjg==
X-Forwarded-Encrypted: i=1; AJvYcCX61My1XTQyPBX8B3cxxEy/kYxmywRaF8c/eYfKceGNpZbvcxTuvM0m51NVN1gsH3OZVX7GmzZlRbRPLQC8xKBF@lists.openwall.com
X-Gm-Message-State: AOJu0YwQfWabv0n1nLwtOm1YwH/vk22wsoSmDWz3++zfxvK/Ujg2I3ts
	f3sxY+7VynxyJIIl0GJGGseglGPTyoytblFHCTkP2CCB2rcvy1DCB3ciCvNiaW+unwkEbYjALwC
	OV4k0dMUME5YbhQU4TaZilCfgrOGDReh8qRTeAxCnbMc4LbiX9UhVkMO0x985Tv9Ab4HuvNI=
X-Gm-Gg: ASbGncvv3hAeAF6sWL1o9ycNWg4phuYvBdThjhQq45fDOuYZnyHzFT/+0XJ+rxXgDl+
	0aDjrfVQnD4QwNYIknwfwfFsOyDxFX6FXvsOIAWz3h6EP66reiTGB2pKWe2GdIf0frAjLcuUOnr
	QcXNIDWQVm/s6Mf7ecMrKfgpWQkBABf2ju5273xz3xhZp9HS4tybmtmq16pontqw6maklMunM42
	jsa5PiS8gSjMryTdUOJla37YdIxR7C1KNyATuAlUrK1FHqXaE6Y0fvtDK95GVRX9flvP6CzhEws
	NrqPswHRirnB
X-Received: by 2002:a05:6512:2392:b0:549:8e54:da9c with SMTP id 2adb3069b0e04-54ad0619d9cmr1163986e87.4.1742481249724;
        Thu, 20 Mar 2025 07:34:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFP5MKiRxkFgKG3EdSlhgqaV6W6DjuZ/y68FT+nnGB1qw2EVv6jr9Oog18ux0YhIZ7JDKVH0g==
X-Received: by 2002:a05:6512:2392:b0:549:8e54:da9c with SMTP id 2adb3069b0e04-54ad0619d9cmr1163951e87.4.1742481249052;
        Thu, 20 Mar 2025 07:34:09 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To: Yunsheng Lin <linyunsheng@huawei.com>, Yunsheng Lin
 <yunshenglin0825@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky
 <leon@kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, Simon
 Horman <horms@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Mina
 Almasry <almasrymina@google.com>, Yonglong Liu <liuyonglong@huawei.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Matthew Wilcox
 <willy@infradead.org>, Robin Murphy <robin.murphy@arm.com>, IOMMU
 <iommu@lists.linux.dev>, segoon@openwall.com, solar@openwall.com,
 kernel-hardening@lists.openwall.com
Cc: netdev@vger.kernel.org, bpf@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-mm@kvack.org, Qiuling Ren <qren@redhat.com>, Yuying Ma
 <yuma@redhat.com>
Subject: Re: [PATCH net-next 3/3] page_pool: Track DMA-mapped pages and
 unmap them when destroying the pool
In-Reply-To: <7a604ae4-063f-48ff-a92f-014d1cf86adc@huawei.com>
References: <20250314-page-pool-track-dma-v1-0-c212e57a74c2@redhat.com>
 <20250314-page-pool-track-dma-v1-3-c212e57a74c2@redhat.com>
 <db813035-fb38-4fc3-b91e-d1416959db13@gmail.com> <87jz8nhelh.fsf@toke.dk>
 <7a76908d-5be2-43f1-a8e2-03b104165a29@huawei.com> <87wmcmhxdz.fsf@toke.dk>
 <ce6ca18b-0eda-4d62-b1d3-e101fe6dcd4e@huawei.com> <87r02ti57p.fsf@toke.dk>
 <7a604ae4-063f-48ff-a92f-014d1cf86adc@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 20 Mar 2025 15:34:06 +0100
Message-ID: <87o6xvixep.fsf@toke.dk>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ViEhe52o1uu9Lt-i6vHIHs2mxtuIBjHI4milCn2jaKc_1742481250
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Yunsheng Lin <linyunsheng@huawei.com> writes:

> On 2025/3/19 20:18, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>
>>> All I asked is about moving PP_MAGIC_MASK macro into poison.h if you
>>> still want to proceed with reusing the page->pp_magic as the masking an=
d
>>> the signature to be masked seems reasonable to be in the same file.
>>=20
>> Hmm, my thinking was that this would be a lot of irrelevant stuff to put
>> into poison.h, but I suppose we could do so if the mm folks don't object=
 :)
>
> The masking and the signature to be masked is correlated, I am not sure
> what you meant by 'irrelevant stuff' here.

Well, looking at it again, mostly the XA_LIMIT define, I guess. But I
can just leave that in the PP header.

> As you seemed to have understood most of my concern about reusing
> page->pp_magic, I am not going to argue with you about the uncertainty
> of security and complexity of different address layout for different
> arches again.
>
> But I am still think it is not the way forward with the reusing of
> page->pp_magic through doing some homework about the 'POISON_POINTER'.
> If you still think my idea is complex and still want to proceed with
> reusing the space of page->pp_magic, go ahead and let the maintainers
> decide if it is worth the security risk and performance degradation.

Yeah, thanks for taking the time to go through the implications. On
balance, I still believe reusing the bits is a better solution, but it
will of course ultimately be up to the maintainers to decide.

I will post a v2 of this series with the adjustments we've discussed,
and try to outline the tradeoffs and risks involved in the description,
and then leave it to the maintainers to decide which approach they want
to move forward with.

-Toke

