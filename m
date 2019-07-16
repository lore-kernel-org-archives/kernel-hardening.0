Return-Path: <SRS0=vl1x=VN=lists.openwall.com=kernel-hardening-return-16478-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D993C76192
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:39:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8B54621743
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:39:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B54621743
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16478-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6033 invoked by uid 550); 16 Jul 2019 18:39:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6008 invoked from network); 16 Jul 2019 18:39:26 -0000
Date: Tue, 16 Jul 2019 11:39:02 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
        kernel-hardening@lists.openwall.com, kernel-team@android.com,
        Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
        netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 3/9] rcu/sync: Remove custom check for reader-section (v2)
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-4-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-4-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
x-cbid: 19071618-0060-0000-0000-0000035F2659
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011440; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233107; UDB=6.00649718; IPR=6.01014419;
 MB=3.00027748; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 18:39:11
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071618-0061-0000-0000-00004A2A2193
Message-Id: <20190716183902.GE14271@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228

On Mon, Jul 15, 2019 at 10:36:59AM -0400, Joel Fernandes (Google) wrote:
> The rcu/sync code was doing its own check whether we are in a reader
> section. With RCU consolidating flavors and the generic helper added in
> this series, this is no longer need. We can just use the generic helper
> and it results in a nice cleanup.
> 
> Cc: Oleg Nesterov <oleg@redhat.com>
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

This one looks good!

							Thanx, Paul

> ---
>  include/linux/rcu_sync.h | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/include/linux/rcu_sync.h b/include/linux/rcu_sync.h
> index 9b83865d24f9..0027d4c8087c 100644
> --- a/include/linux/rcu_sync.h
> +++ b/include/linux/rcu_sync.h
> @@ -31,9 +31,7 @@ struct rcu_sync {
>   */
>  static inline bool rcu_sync_is_idle(struct rcu_sync *rsp)
>  {
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
> -			 !rcu_read_lock_bh_held() &&
> -			 !rcu_read_lock_sched_held(),
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),
>  			 "suspicious rcu_sync_is_idle() usage");
>  	return !READ_ONCE(rsp->gp_state); /* GP_IDLE */
>  }
> -- 
> 2.22.0.510.g264f2c817a-goog
> 

