Return-Path: <SRS0=89Vp=5S=lists.openwall.com=kernel-hardening-return-18402-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C2D5C43331
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 22:50:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 58D022072E
	for <kernel-hardening@archiver.kernel.org>; Thu,  2 Apr 2020 22:50:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58D022072E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=iogearbox.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18402-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22396 invoked by uid 550); 2 Apr 2020 22:50:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22362 invoked from network); 2 Apr 2020 22:50:17 -0000
Subject: Re: [PATCH v5 bpf] kbuild: fix dependencies for DEBUG_INFO_BTF
To: Slava Bacherikov <slava@bacher09.org>, andriin@fb.com
Cc: keescook@chromium.org, bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 jannh@google.com, alexei.starovoitov@gmail.com,
 kernel-hardening@lists.openwall.com, liuyd.fnst@cn.fujitsu.com,
 kpsingh@google.com
References: <202004021328.E6161480@keescook>
 <20200402204138.408021-1-slava@bacher09.org>
From: Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <f55123e4-4034-b22a-a509-4ddf40f1ca22@iogearbox.net>
Date: Fri, 3 Apr 2020 00:49:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200402204138.408021-1-slava@bacher09.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25770/Thu Apr  2 14:58:54 2020)

On 4/2/20 10:41 PM, Slava Bacherikov wrote:
> Currently turning on DEBUG_INFO_SPLIT when DEBUG_INFO_BTF is also
> enabled will produce invalid btf file, since gen_btf function in
> link-vmlinux.sh script doesn't handle *.dwo files.
> 
> Enabling DEBUG_INFO_REDUCED will also produce invalid btf file, and
> using GCC_PLUGIN_RANDSTRUCT with BTF makes no sense.
> 
> Signed-off-by: Slava Bacherikov <slava@bacher09.org>
> Reported-by: Jann Horn <jannh@google.com>
> Reported-by: Liu Yiding <liuyd.fnst@cn.fujitsu.com>
> Acked-by: KP Singh <kpsingh@google.com>
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Fixes: e83b9f55448a ("kbuild: add ability to generate BTF type info for vmlinux")

Applied, thanks!
