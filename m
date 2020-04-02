Return-Path: <SRS0=vTQU=5S=lists.openwall.com=kernel-hardening-return-18386-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDA9C2BA12
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 15:40:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EFC3020737
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 15:40:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=bacher09.org header.i=@bacher09.org header.b="rp5rZGQM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EFC3020737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=bacher09.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18386-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3415 invoked by uid 550); 2 Apr 2020 15:40:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3380 invoked from network); 2 Apr 2020 15:40:31 -0000
Subject: Re: [PATCH v4 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bacher09.org;
	s=reg; t=1585842020;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GZLGLGK0Ts+nwMLTKpmMA0gphkPeoQjdvofgRxfo/XQ=;
	b=rp5rZGQMd0ceRJDBWcpjiTnamXyUc3Rl/Y4P4pOlgIRcRqMERZduQGjA0aCXJhoQ25trW7
	dYNDBhqoGw2qpfMPpU7A9i4hNv3FUhWGxozJ2zJFJ3mZjVJ/95UG0TJmPCuQxiHrsOx/xS
	s7bKQF55nqFd0X5/wZIkfL5QFa91urI=
Cc: Kees Cook <keescook@chromium.org>, bpf@vger.kernel.org,
 linux-kernel@vger.kernel.org, jannh@google.com,
 alexei.starovoitov@gmail.com, daniel@iogearbox.net,
 kernel-hardening@lists.openwall.com, liuyd.fnst@cn.fujitsu.com,
 kpsingh@google.com
References: <202004010849.CC7E9412@keescook>
 <20200402153335.38447-1-slava@bacher09.org>
To: Andrii Nakryiko <andriin@fb.com>
From: Slava Bacherikov <slava@bacher09.org>
Autocrypt: addr=slava@bacher09.org; prefer-encrypt=mutual; keydata=
 mQINBFFdcIUBEAC9HZz+DbqCs+jyJjpvRyped8U4bz716OZKvZCTH4fNxrrV0fYWRn7LJ/dU
 r5tBnwhmlTWD4v6hk88qpD9flagkSP4UuIAo+3aopxvrkyWXXYiEAjSL2uTFolcEO40HuYPk
 7nprTEzHcHgcYq2wzJfE046gimzFYcUXkrv1gC89RdkwOgLTFb80QUpKyVeoKJWKWHPfRqGF
 FxpFwMnW3IrgZhOnl8X859WwKUc/agPz05LjaksGpAP8ayfruxtG/3Hl7OulYPWIkTuxHAtK
 xW9QL7Vt24P8rVLC7sgNZYcjaOcY70PCkGLnquETuIeeCwhKr/e2n+ymH+CxlAiUY+blNpO5
 S5P+rwb0qPvGDzjF+Drdp0ye/S3kMa+FNrELW06Fp74p7BgsPgNsuBVg300JWMFXiS7YeMZV
 cyedAzGbcO8yxrY6ZnuNF8rLiZOYde79yN82wTNw/fWZtHhz8QJELZzMNjZd3/w61ztSs9ng
 mduiqv9EyNKlEEuxy6N4jGTQ2YYLE/YcIx654rCfpJWJhj2kDd4k2uNRrhJI7t4duHC86K4M
 HiOwC7PIKlIbtrpYnTZPXXcQHp69LDzxCAA6dgGkhjZsUTVci0rTEfRQjkXYvK/f3P1SHF1M
 EHoeEaclqvpkuvPcbHQ/TBwBJs+ekdFCTmBzv0UwqZKfaPW5yQARAQABtDJTbGF2YSBCYWNo
 ZXJpa292IChNeSBOZXcgS2V5KSA8c2xhdmFAYmFjaGVyMDkub3JnPokCWQQTAQIAQwIbIwUJ
 DShogAcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAFiEEZkmc+DLOftzkG8AWUSYbvb34nfMF
 AlkF95wCGQEACgkQUSYbvb34nfO7FQ//drNtAxFi294vVZnN+wyVimXGiyBHpBPnEK5/hSQ5
 oBVvjFl8Ws7q13WWklhdPgM3atAukADMG5wr3IM3ctS1L2+502TYGv8W5jvUlso/TxjNdVQz
 SDicmPCMMs91BWHiJHkYKErUXxNtCaBQqVV2rAKiDoK1gtFrWfH/3OgP6RS+mLMt5eJ/PHsc
 kAuvaXOIzWxjclGMB2yAQzmK7SImOHp7YUBqXrOt523sz29p+1q0+y6ZRlPNctys/okUdnoK
 bi0rMBqbHngaoi/al9Clh9jrhqjZHJLPSM091u3ubuQkvtg3BOhqs0I/b7Xz83VxN0pj8XHI
 z4MRFwfhVSKW4pRLf92DKAa9PEYxA9QtboKafZG2EJfrUauba29/JoIh8Evi5MIuWNeZK7pK
 t3+NadAwXwcLP4RlLuOkVrF+DAuhEktvdJBvTfUkipeQo3YGcffm1daJWoUKiP2a3tqJ9fz8
 Zd5cy8hvKFCv5VsoqF2voc6uaadH1/Pwylnw2fzTfGzFP0bsz/HI8F7g3WFv0PrrtkXnPUCD
 2IbmIGe8fi7NBTIqtc+mDMsqOIa4hlLBGkP8jHnCPv6oaGYlWemzcVhehU3XQOKyT2lroZan
 nnARpEW9lSSeWPba99+PJu0q2rEaQj/Vhy/m2db89kYeLcEuItd4DYKk7rHZSrHBKwM=
Message-ID: <f43f4e17-f496-9ee1-7d89-c8f742720a5f@bacher09.org>
Date: Thu, 2 Apr 2020 18:40:19 +0300
MIME-Version: 1.0
In-Reply-To: <20200402153335.38447-1-slava@bacher09.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



02.04.2020 18:33, Slava Bacherikov wrote:
> +	depends on DEBUG_INFO || COMPILE_TEST

Andrii are you fine by this ?
