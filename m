Return-Path: <SRS0=JmbV=VN=lists.openwall.com=kernel-hardening-return-16482-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F25C76192
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:42:27 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7605621743
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:42:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7605621743
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16482-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 16012 invoked by uid 550); 16 Jul 2019 18:42:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15985 invoked from network); 16 Jul 2019 18:42:18 -0000
Date: Tue, 16 Jul 2019 11:41:19 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
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
        netdev@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Pavel Machek <pavel@ucw.cz>, peterz@infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>, rcu@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, will@kernel.org,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 6/9] workqueue: Convert for_each_wq to use built-in list
 check (v2)
Message-ID: <20190716184119.GH14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-7-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-7-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228

On Mon, Jul 15, 2019 at 10:37:02AM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu now has support to check for RCU reader sections
> as well as lock. Just use the support in it, instead of explictly
> checking in the caller.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

We need an ack from one of the subsystem maintainers on this one.

							Thanx, Paul

> ---
>  kernel/workqueue.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 601d61150b65..e882477ebf6e 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -364,11 +364,6 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
>  			 !lockdep_is_held(&wq_pool_mutex),		\
>  			 "RCU or wq_pool_mutex should be held")
>  
> -#define assert_rcu_or_wq_mutex(wq)					\
> -	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
> -			 !lockdep_is_held(&wq->mutex),			\
> -			 "RCU or wq->mutex should be held")
> -
>  #define assert_rcu_or_wq_mutex_or_pool_mutex(wq)			\
>  	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&			\
>  			 !lockdep_is_held(&wq->mutex) &&		\
> @@ -425,9 +420,8 @@ static void workqueue_sysfs_unregister(struct workqueue_struct *wq);
>   * ignored.
>   */
>  #define for_each_pwq(pwq, wq)						\
> -	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node)		\
> -		if (({ assert_rcu_or_wq_mutex(wq); false; })) { }	\
> -		else
> +	list_for_each_entry_rcu((pwq), &(wq)->pwqs, pwqs_node,		\
> +				 lock_is_held(&(wq->mutex).dep_map))
>  
>  #ifdef CONFIG_DEBUG_OBJECTS_WORK
>  
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
