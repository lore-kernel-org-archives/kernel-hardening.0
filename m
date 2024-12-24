Return-Path: <kernel-hardening-return-21912-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 3CBD6E7718D
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Dec 2024 22:42:46 +0000 (UTC)
Received: (qmail 8012 invoked by uid 550); 24 Dec 2024 22:42:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7986 invoked from network); 24 Dec 2024 22:42:33 -0000
X-Authority-Analysis: v=2.4 cv=KOBcDkFo c=1 sm=1 tr=0 ts=676b38cf
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=GtNDhlRIH4u8wNL3EA3KcA==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7T7KSl7uo7wA:10 a=VwQbUJbxAAAA:8
 a=NEAV23lmAAAA:8 a=oOqFFZS7AAAA:8 a=8gwe23exSknoF3-mrEwA:9 a=QEXdDO2ut3YA:10
 a=9cHFzqQdt-sA:10 a=PUnBvhIW4WwA:10 a=cEm2zIq8e6p76x6pLsf5:22
 a=Xt_RvD8W3m28Mn_h3AK8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=na2/0I+XXDoadhe2QTikJdF+DpeX36K5jAfWFUya8rQ=; b=wE8KaOf4zXbKZ7yWtXtAWc1EyY
	8TYTKZjfaFU5owzlTFbsimAUHnLnjHKNEQ9THMKMdjskKQG3arjgBiRMuuxO95gjnz7UIVxoS2MPa
	FvmtEWi9J8fDQZJrgwbBaaU/mYwbmsGuhGlSDD5DQ9Mi0WS03bG52w2r3CCA72yXM3MwLvv91xs6/
	jZLrRrSr/5FWinbHIz/nOHwn2fQb2ejpaWeBmFuXw+wDCYf7bMc04PLZV3gUWSr1n2Z0DUvNLI50F
	2X2/v6+x5B8nb6veE4kY9Ma1k5Ev+Vvmlx2SsDcxf9PI56nEPHK+v1X/diMgLB78gqJRVIEi7ZqXo
	w4Suying==;
Message-ID: <d38e99d7-1f24-4c7b-87de-111c345b02cf@embeddedor.com>
Date: Tue, 24 Dec 2024 16:42:07 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] dm: change kzalloc to kcalloc
To: Ethan Carter Edwards <ethan@ethancedwards.com>,
 "agk@redhat.com" <agk@redhat.com>
Cc: "snitzer@kernel.org" <snitzer@kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
 "mpatocka@redhat.com" <mpatocka@redhat.com>
References: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Content-Language: en-US
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <Z7XWRfRi3Fn25wT4Dg19JRN4xrKcCt3TxaxZwsR_0LDR2C6fQxCiLrsMBfJg8f_ZqSAx3u6aPm-TR02dC6bLpMmqSI_jp_ADiJ_qW_27puk=@ethancedwards.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - lists.openwall.com
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 177.238.21.80
X-Source-L: No
X-Exim-ID: 1tQDba-002hf6-0r
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: ([192.168.0.21]) [177.238.21.80]:33898
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Org: HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFpKW1fDF81P6cq97ZP1h6FYln4v0CBB1LTs8NHgnkDFf3LBVZh9Url/OYk4oZcozTDMT5IoiSEv1pJJCP9ePX2QQzfwGOVMNiBxgnrb2/5WJWNNYJ4+
 D2TYq1mV3Mgtp5Xiplc/kvomYV7LVqYTB/Sfd1WLBZSdIxDC5trfEDfXCsZFpgOBpSIwswfa3z2zhmOrCOg7c0phEqkg4eNRvRGIunI4dN2QkSJJYoDZ317h



On 24/12/24 16:13, Ethan Carter Edwards wrote:
> Use 2-factor multiplication argument form kcalloc() instead
> of instead of the deprecated kzalloc() [1].

Thanks for the patch - Just note that kzalloc() is by no means
deprecated.

> 
> [1] https://www.kernel.org/doc/html/next/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments
> Link: https://github.com/KSPP/linux/issues/162
> 
> Signed-off-by: Ethan Carter Edwards <ethan@ethancedwards.com>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

-Gustavo

> ---
>   drivers/md/dm-ps-io-affinity.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/dm-ps-io-affinity.c b/drivers/md/dm-ps-io-affinity.c
> index 461ee6b2044d..716807e511ee 100644
> --- a/drivers/md/dm-ps-io-affinity.c
> +++ b/drivers/md/dm-ps-io-affinity.c
> @@ -116,7 +116,7 @@ static int ioa_create(struct path_selector *ps, unsigned int argc, char **argv)
>   	if (!s)
>   		return -ENOMEM;
>   
> -	s->path_map = kzalloc(nr_cpu_ids * sizeof(struct path_info *),
> +	s->path_map = kcalloc(nr_cpu_ids, sizeof(struct path_info *),
>   			     GFP_KERNEL);
>   	if (!s->path_map)
>   		goto free_selector;

