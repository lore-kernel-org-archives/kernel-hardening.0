Return-Path: <SRS0=xsmk=WC=lists.openwall.com=kernel-hardening-return-16728-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA75DC433FF
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 16:25:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1E2A32086D
	for <kernel-hardening@archiver.kernel.org>; Tue,  6 Aug 2019 16:25:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E2A32086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16728-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30536 invoked by uid 550); 6 Aug 2019 16:25:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30500 invoked from network); 6 Aug 2019 16:25:37 -0000
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro
 <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale
 <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa
 <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
 <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
 <a870c2c9-d2f7-e0fa-c8cc-35dbf8b5b87d@ssi.gouv.fr>
 <CAADnVQLqkfVijWoOM29PxCL_yK6K0fr8B89r4c5EKgddevJhGQ@mail.gmail.com>
 <59e8fab9-34df-0ebe-ca6b-8b34bf582b75@ssi.gouv.fr>
 <20190801173534.etfls5ltixp5hfrh@ast-mbp.dhcp.thefacebook.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <9c64ff70-b3bb-d4ad-0d57-e4c941c61503@digikod.net>
Date: Tue, 6 Aug 2019 18:24:12 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20190801173534.etfls5ltixp5hfrh@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 01/08/2019 19:35, Alexei Starovoitov wrote:
> On Wed, Jul 31, 2019 at 09:11:10PM +0200, Mickaël Salaün wrote:
>>
>>
>> On 31/07/2019 20:58, Alexei Starovoitov wrote:
>>> On Wed, Jul 31, 2019 at 11:46 AM Mickaël Salaün
>>> <mickael.salaun@ssi.gouv.fr> wrote:
>>>>>> +    for (i = 0; i < htab->n_buckets; i++) {
>>>>>> +            head = select_bucket(htab, i);
>>>>>> +            hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
>>>>>> +                    landlock_inode_remove_map(*((struct inode **)l->key), map);
>>>>>> +            }
>>>>>> +    }
>>>>>> +    htab_map_free(map);
>>>>>> +}
>>>>>
>>>>> user space can delete the map.
>>>>> that will trigger inode_htab_map_free() which will call
>>>>> landlock_inode_remove_map().
>>>>> which will simply itereate the list and delete from the list.
>>>>
>>>> landlock_inode_remove_map() removes the reference to the map (being
>>>> freed) from the inode (with an RCU lock).
>>>
>>> I'm going to ignore everything else for now and focus only on this bit,
>>> since it's fundamental issue to address before this discussion can
>>> go any further.
>>> rcu_lock is not a spin_lock. I'm pretty sure you know this.
>>> But you're arguing that it's somehow protecting from the race
>>> I mentioned above?
>>>
>>
>> I was just clarifying your comment to avoid misunderstanding about what
>> is being removed.
>>
>> As said in the full response, there is currently a race but, if I add a
>> bpf_map_inc() call when the map is referenced by inode->security, then I
>> don't see how a race could occur because such added map could only be
>> freed in a security_inode_free() (as long as it retains a reference to
>> this inode).
> 
> then it will be a cycle and a map will never be deleted?
> closing map_fd should delete a map. It cannot be alive if it's not
> pinned in bpffs, there are no FDs that are holding it, and no progs using it.
> So the map deletion will iterate over inodes that belong to this map.
> In parallel security_inode_free() will be called that will iterate
> over its link list that contains elements from different maps.
> So the same link list is modified by two cpus.
> Where is a lock that protects from concurrent links list manipulations?

Ok, I think I got it. What about this fix?

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 4fc7755042f0..3226e50b6211 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -1708,10 +1708,16 @@ static void inode_htab_map_free(struct bpf_map *map)

 	for (i = 0; i < htab->n_buckets; i++) {
 		head = select_bucket(htab, i);
-		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
+		rcu_read_lock();
+		hlist_nulls_for_each_entry_rcu(l, n, head, hash_node) {
 			landlock_inode_remove_map(*((struct inode **)l->key), map);
 		}
+		rcu_read_unlock();
 	}
+	/*
+	 * The last pending put_landlock_inode_map() may be called here, before
+	 * the rcu_barrier() from htab_map_free().
+	 */
 	htab_map_free(map);
 }

diff --git a/security/landlock/common.h b/security/landlock/common.h
index b0ba3f31ac7d..535c6a4292b9 100644
--- a/security/landlock/common.h
+++ b/security/landlock/common.h
@@ -58,6 +58,11 @@ struct landlock_prog_set {
 	refcount_t usage;
 };

+struct landlock_inode_security {
+	struct list_head list;
+	spinlock_t lock;
+};
+
 struct landlock_inode_map {
 	struct list_head list;
 	struct rcu_head rcu_put;
diff --git a/security/landlock/hooks_fs.c b/security/landlock/hooks_fs.c
index 8c9d6a333111..b9bfd558f8b8 100644
--- a/security/landlock/hooks_fs.c
+++ b/security/landlock/hooks_fs.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h> /* ARRAY_SIZE */
 #include <linux/lsm_hooks.h>
 #include <linux/rcupdate.h> /* synchronize_rcu() */
+#include <linux/spinlock.h>
 #include <linux/stat.h> /* S_ISDIR */
 #include <linux/stddef.h> /* offsetof */
 #include <linux/types.h> /* uintptr_t */
@@ -251,13 +252,16 @@ static int hook_sb_pivotroot(const struct path *old_path,

 /* inode helpers */

-static inline struct list_head *inode_landlock(const struct inode *inode)
+static inline struct landlock_inode_security *inode_landlock(
+		const struct inode *inode)
 {
 	return inode->i_security + landlock_blob_sizes.lbs_inode;
 }

 int landlock_inode_add_map(struct inode *inode, struct bpf_map *map)
 {
+	unsigned long flags;
+	struct landlock_inode_security *inode_sec = inode_landlock(inode);
 	struct landlock_inode_map *inode_map;

 	inode_map = kzalloc(sizeof(*inode_map), GFP_ATOMIC);
@@ -266,60 +270,66 @@ int landlock_inode_add_map(struct inode *inode, struct bpf_map *map)
 	INIT_LIST_HEAD(&inode_map->list);
 	inode_map->map = map;
 	inode_map->inode = inode;
-	list_add_tail(&inode_map->list, inode_landlock(inode));
+	spin_lock_irqsave(&inode_sec->lock, flags);
+	list_add_tail_rcu(&inode_map->list, &inode_sec->list);
+	spin_unlock_irqrestore(&inode_sec->lock, flags);
 	return 0;
 }

 static void put_landlock_inode_map(struct rcu_head *head)
 {
 	struct landlock_inode_map *inode_map;
-	int err;

 	inode_map = container_of(head, struct landlock_inode_map, rcu_put);
-	err = bpf_inode_ptr_unlocked_htab_map_delete_elem(inode_map->map,
+	bpf_inode_ptr_unlocked_htab_map_delete_elem(inode_map->map,
 			&inode_map->inode, false);
-	bpf_map_put(inode_map->map);
 	kfree(inode_map);
 }

 void landlock_inode_remove_map(struct inode *inode, const struct bpf_map *map)
 {
+	unsigned long flags;
+	struct landlock_inode_security *inode_sec = inode_landlock(inode);
 	struct landlock_inode_map *inode_map;
-	bool found = false;

+	spin_lock_irqsave(&inode_sec->lock, flags);
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode_map, inode_landlock(inode), list) {
+	list_for_each_entry_rcu(inode_map, &inode_sec->list, list) {
 		if (inode_map->map == map) {
-			found = true;
 			list_del_rcu(&inode_map->list);
 			kfree_rcu(inode_map, rcu_put);
 			break;
 		}
 	}
 	rcu_read_unlock();
-	WARN_ON(!found);
+	spin_unlock_irqrestore(&inode_sec->lock, flags);
 }

 /* inode hooks */

 static int hook_inode_alloc_security(struct inode *inode)
 {
-	struct list_head *ll_inode = inode_landlock(inode);
+	struct landlock_inode_security *inode_sec = inode_landlock(inode);

-	INIT_LIST_HEAD(ll_inode);
+	INIT_LIST_HEAD(&inode_sec->list);
+	spin_lock_init(&inode_sec->lock);
 	return 0;
 }

 static void hook_inode_free_security(struct inode *inode)
 {
+	unsigned long flags;
+	struct landlock_inode_security *inode_sec = inode_landlock(inode);
 	struct landlock_inode_map *inode_map;

+	spin_lock_irqsave(&inode_sec->lock, flags);
 	rcu_read_lock();
-	list_for_each_entry_rcu(inode_map, inode_landlock(inode), list) {
+	list_for_each_entry_rcu(inode_map, &inode_sec->list, list) {
 		list_del_rcu(&inode_map->list);
 		call_rcu(&inode_map->rcu_put, put_landlock_inode_map);
 	}
 	rcu_read_unlock();
+	spin_unlock_irqrestore(&inode_sec->lock, flags);
 }

 /* a directory inode contains only one dentry */
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 35165fc8a595..1305255f5d2e 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -137,7 +137,7 @@ static int __init landlock_init(void)
 }

 struct lsm_blob_sizes landlock_blob_sizes __lsm_ro_after_init = {
-	.lbs_inode = sizeof(struct list_head),
+	.lbs_inode = sizeof(struct landlock_inode_security),
 };

 DEFINE_LSM(LANDLOCK_NAME) = {


> 
>> Les données à caractère personnel recueillies et traitées dans le cadre de cet échange, le sont à seule fin d’exécution d’une relation professionnelle et s’opèrent dans cette seule finalité et pour la durée nécessaire à cette relation. Si vous souhaitez faire usage de vos droits de consultation, de rectification et de suppression de vos données, veuillez contacter contact.rgpd@sgdsn.gouv.fr. Si vous avez reçu ce message par erreur, nous vous remercions d’en informer l’expéditeur et de détruire le message. The personal data collected and processed during this exchange aims solely at completing a business relationship and is limited to the necessary duration of that relationship. If you wish to use your rights of consultation, rectification and deletion of your data, please contact: contact.rgpd@sgdsn.gouv.fr. If you have received this message in error, we thank you for informing the sender and destroying the message.
> 
> Please get rid of this. It's absolutely not appropriate on public mailing list.
> Next time I'd have to ignore emails that contain such disclaimers.

Unfortunately this message is automatically appended (server-side) to all my
professional emails...
