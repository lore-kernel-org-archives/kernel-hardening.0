Return-Path: <SRS0=bzJR=VN=lists.openwall.com=kernel-hardening-return-16481-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B71CC7618F
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:41:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7A60221743
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jul 2019 18:41:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7A60221743
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16481-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13804 invoked by uid 550); 16 Jul 2019 18:41:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13783 invoked from network); 16 Jul 2019 18:41:23 -0000
Date: Tue, 16 Jul 2019 11:40:25 -0700
From: "Paul E. McKenney" <paulmck@linux.ibm.com>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
        c0d1n61at3@gmail.com, "David S. Miller" <davem@davemloft.net>,
        edumazet@google.com, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
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
Subject: Re: [PATCH 5/9] driver/core: Convert to use built-in RCU list
 checking (v1)
Message-ID: <20190716184025.GG14271@linux.ibm.com>
References: <20190715143705.117908-1-joel@joelfernandes.org>
 <20190715143705.117908-6-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715143705.117908-6-joel@joelfernandes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160228

On Mon, Jul 15, 2019 at 10:37:01AM -0400, Joel Fernandes (Google) wrote:
> list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
> it in driver core.
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

This one looks ready.

							Thanx, Paul

> ---
>  drivers/base/base.h          |  1 +
>  drivers/base/core.c          | 10 ++++++++++
>  drivers/base/power/runtime.c | 15 ++++++++++-----
>  3 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index b405436ee28e..0d32544b6f91 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -165,6 +165,7 @@ static inline int devtmpfs_init(void) { return 0; }
>  /* Device links support */
>  extern int device_links_read_lock(void);
>  extern void device_links_read_unlock(int idx);
> +extern int device_links_read_lock_held(void);
>  extern int device_links_check_suppliers(struct device *dev);
>  extern void device_links_driver_bound(struct device *dev);
>  extern void device_links_driver_cleanup(struct device *dev);
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index da84a73f2ba6..85e82f38717f 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -68,6 +68,11 @@ void device_links_read_unlock(int idx)
>  {
>  	srcu_read_unlock(&device_links_srcu, idx);
>  }
> +
> +int device_links_read_lock_held(void)
> +{
> +	return srcu_read_lock_held(&device_links_srcu);
> +}
>  #else /* !CONFIG_SRCU */
>  static DECLARE_RWSEM(device_links_lock);
>  
> @@ -91,6 +96,11 @@ void device_links_read_unlock(int not_used)
>  {
>  	up_read(&device_links_lock);
>  }
> +
> +int device_links_read_lock_held(void)
> +{
> +	return lock_is_held(&device_links_lock);
> +}
>  #endif /* !CONFIG_SRCU */
>  
>  /**
> diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
> index 952a1e7057c7..7a10e8379a70 100644
> --- a/drivers/base/power/runtime.c
> +++ b/drivers/base/power/runtime.c
> @@ -287,7 +287,8 @@ static int rpm_get_suppliers(struct device *dev)
>  {
>  	struct device_link *link;
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held()) {
>  		int retval;
>  
>  		if (!(link->flags & DL_FLAG_PM_RUNTIME) ||
> @@ -309,7 +310,8 @@ static void rpm_put_suppliers(struct device *dev)
>  {
>  	struct device_link *link;
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held()) {
>  		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
>  			continue;
>  
> @@ -1640,7 +1642,8 @@ void pm_runtime_clean_up_links(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.consumers, s_node) {
> +	list_for_each_entry_rcu(link, &dev->links.consumers, s_node,
> +				device_links_read_lock_held()) {
>  		if (link->flags & DL_FLAG_STATELESS)
>  			continue;
>  
> @@ -1662,7 +1665,8 @@ void pm_runtime_get_suppliers(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held())
>  		if (link->flags & DL_FLAG_PM_RUNTIME) {
>  			link->supplier_preactivated = true;
>  			refcount_inc(&link->rpm_active);
> @@ -1683,7 +1687,8 @@ void pm_runtime_put_suppliers(struct device *dev)
>  
>  	idx = device_links_read_lock();
>  
> -	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
> +	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
> +				device_links_read_lock_held())
>  		if (link->supplier_preactivated) {
>  			link->supplier_preactivated = false;
>  			if (refcount_dec_not_one(&link->rpm_active))
> -- 
> 2.22.0.510.g264f2c817a-goog
> 
