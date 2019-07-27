Return-Path: <SRS0=fdE2=VY=lists.openwall.com=kernel-hardening-return-16596-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59580C7618F
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jul 2019 01:41:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 471E422BE8
	for <kernel-hardening@archiver.kernel.org>; Sat, 27 Jul 2019 01:41:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFVyyOjf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 471E422BE8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16596-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32366 invoked by uid 550); 27 Jul 2019 01:41:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32330 invoked from network); 27 Jul 2019 01:41:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=gK35F/yyyAGVAhDCeXp9WzvvG/sG2XiEcs/uV4YadWQ=;
        b=LFVyyOjfNHS5klS8qdwlzS4nlK50X8hlkagr8LMzc/jV9zfcPf4cOen+5zHp4Tqm+p
         qDI6j9lBnC+tgufQduGMWfWJA5ZNNv1Zf7/dibwt7LKluGEjk85yTQBeeTxXFXj6nbYV
         NT3q35KGzXjUKF6B2+cCK5t65hrg0ok5w6KpWbHMHlrBlJ0YC+c0apMVvixIu+Kw4295
         jmsN2sbEdyTRYqU0UWPsk40yMYuDK/xW2q817rNs/Zup4cLvopBeVDczhLmFOlgtuDSF
         AN04Ei7iPrlm6VdrHjVV/ARocEADLTQHgQo1+0mhRgvXBpqJSQv+aaLejP7VGpgJoriB
         O1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=gK35F/yyyAGVAhDCeXp9WzvvG/sG2XiEcs/uV4YadWQ=;
        b=bC6UMECo32QifhKTp7qWPG4AVTaVqu2tmMpNy/E82nHfnI/Q3q9IlhIZv3VzFDMPZ8
         M7oUClK7EH+ouCq79+qKMeEhZD/lA7rHnqDm7vr6m0K60DJ2QZzXXLbxXLq9jBdJ5M78
         H6ialalj4YbFocW+Ba9JpuC60tMT7E5TvuDMOsMKrH8qnVi7JWKP/uLbyp4cPBVaJrQ/
         05WxzG4iqMK4n4kOZX7xkhDmntuSxg6tqnZnznf3KZ+rKig24xP84yoXljQMqCs/SGRy
         o6Qobe6ME+gO8AeXi45w63flfHEzbojKaCFn8TO0AkfWOi1XyhD+bPZvZgIeqEkrwwPj
         GR7g==
X-Gm-Message-State: APjAAAXFaQRmVf/zXKgWKysTgGp1mHkjehcApkDpEll4Y2H7Dm3CAnfc
	I4xT+bpvfNcSjmkj//qJ4k8=
X-Google-Smtp-Source: APXvYqzzDzj6NQHlQ79JDLA4ABdSdbB/e7wCK4Qm80OR/rDXBPszVKWLf1Y0e+y3qWjFWx3BKK2zzg==
X-Received: by 2002:a63:5754:: with SMTP id h20mr53429148pgm.195.1564191652726;
        Fri, 26 Jul 2019 18:40:52 -0700 (PDT)
Date: Fri, 26 Jul 2019 18:40:50 -0700
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	David Drysdale <drysdale@google.com>,
	"David S . Miller" <davem@davemloft.net>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Shuah Khan <shuah@kernel.org>, Stephen Smalley <sds@tycho.nsa.gov>,
	Tejun Heo <tj@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
	Will Drewry <wad@chromium.org>, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 06/10] bpf,landlock: Add a new map type:
 inode
Message-ID: <20190727014048.3czy3n2hi6hfdy3m@ast-mbp.dhcp.thefacebook.com>
References: <20190721213116.23476-1-mic@digikod.net>
 <20190721213116.23476-7-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190721213116.23476-7-mic@digikod.net>
User-Agent: NeoMutt/20180223

On Sun, Jul 21, 2019 at 11:31:12PM +0200, Mickaël Salaün wrote:
> FIXME: 64-bits in the doc
> 
> This new map store arbitrary values referenced by inode keys.  The map
> can be updated from user space with file descriptor pointing to inodes
> tied to a file system.  From an eBPF (Landlock) program point of view,
> such a map is read-only and can only be used to retrieved a value tied
> to a given inode.  This is useful to recognize an inode tagged by user
> space, without access right to this inode (i.e. no need to have a write
> access to this inode).
> 
> Add dedicated BPF functions to handle this type of map:
> * bpf_inode_htab_map_update_elem()
> * bpf_inode_htab_map_lookup_elem()
> * bpf_inode_htab_map_delete_elem()
> 
> This new map require a dedicated helper inode_map_lookup_elem() because
> of the key which is a pointer to an opaque data (only provided by the
> kernel).  This act like a (physical or cryptographic) key, which is why
> it is also not allowed to get the next key.
> 
> Signed-off-by: Mickaël Salaün <mic@digikod.net>

there are too many things to comment on.
Let's do this patch.

imo inode_map concept is interesting, but see below...

> +
> +	/*
> +	 * Limit number of entries in an inode map to the maximum number of
> +	 * open files for the current process. The maximum number of file
> +	 * references (including all inode maps) for a process is then
> +	 * (RLIMIT_NOFILE - 1) * RLIMIT_NOFILE. If the process' RLIMIT_NOFILE
> +	 * is 0, then any entry update is forbidden.
> +	 *
> +	 * An eBPF program can inherit all the inode map FD. The worse case is
> +	 * to fill a bunch of arraymaps, create an eBPF program, close the
> +	 * inode map FDs, and start again. The maximum number of inode map
> +	 * entries can then be close to RLIMIT_NOFILE^3.
> +	 */
> +	if (attr->max_entries > rlimit(RLIMIT_NOFILE))
> +		return -EMFILE;

rlimit is checked, but no fd are consumed.
Once created such inode map_fd can be passed to a different process.
map_fd can be pinned into bpffs.
etc.
what the value of the check?

> +
> +	/* decorelate UAPI from kernel API */
> +	attr->key_size = sizeof(struct inode *);
> +
> +	return htab_map_alloc_check(attr);
> +}
> +
> +static void inode_htab_put_key(void *key)
> +{
> +	struct inode **inode = key;
> +
> +	if ((*inode)->i_state & I_FREEING)
> +		return;

checking the state without take a lock? isn't it racy?

> +	iput(*inode);
> +}
> +
> +/* called from syscall or (never) from eBPF program */
> +static int map_get_next_no_key(struct bpf_map *map, void *key, void *next_key)
> +{
> +	/* do not leak a file descriptor */

what this comment suppose to mean?

> +	return -ENOTSUPP;
> +}
> +
> +/* must call iput(inode) after this call */
> +static struct inode *inode_from_fd(int ufd, bool check_access)
> +{
> +	struct inode *ret;
> +	struct fd f;
> +	int deny;
> +
> +	f = fdget(ufd);
> +	if (unlikely(!f.file))
> +		return ERR_PTR(-EBADF);
> +	/* TODO?: add this check when called from an eBPF program too (already
> +	* checked by the LSM parent hooks anyway) */
> +	if (unlikely(IS_PRIVATE(file_inode(f.file)))) {
> +		ret = ERR_PTR(-EINVAL);
> +		goto put_fd;
> +	}
> +	/* check if the FD is tied to a mount point */
> +	/* TODO?: add this check when called from an eBPF program too */
> +	if (unlikely(f.file->f_path.mnt->mnt_flags & MNT_INTERNAL)) {
> +		ret = ERR_PTR(-EINVAL);
> +		goto put_fd;
> +	}

a bunch of TODOs do not inspire confidence.

> +	if (check_access) {
> +		/*
> +		* must be allowed to access attributes from this file to then
> +		* be able to compare an inode to its map entry
> +		*/
> +		deny = security_inode_getattr(&f.file->f_path);
> +		if (deny) {
> +			ret = ERR_PTR(deny);
> +			goto put_fd;
> +		}
> +	}
> +	ret = file_inode(f.file);
> +	ihold(ret);
> +
> +put_fd:
> +	fdput(f);
> +	return ret;
> +}
> +
> +/*
> + * The key is a FD when called from a syscall, but an inode address when called
> + * from an eBPF program.
> + */
> +
> +/* called from syscall */
> +int bpf_inode_fd_htab_map_lookup_elem(struct bpf_map *map, int *key, void *value)
> +{
> +	void *ptr;
> +	struct inode *inode;
> +	int ret;
> +
> +	/* check inode access */
> +	inode = inode_from_fd(*key, true);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +
> +	rcu_read_lock();
> +	ptr = htab_map_lookup_elem(map, &inode);
> +	iput(inode);
> +	if (IS_ERR(ptr)) {
> +		ret = PTR_ERR(ptr);
> +	} else if (!ptr) {
> +		ret = -ENOENT;
> +	} else {
> +		ret = 0;
> +		copy_map_value(map, value, ptr);
> +	}
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +/* called from kernel */

wrong comment?
kernel side cannot call it, right?

> +int bpf_inode_ptr_locked_htab_map_delete_elem(struct bpf_map *map,
> +		struct inode **key, bool remove_in_inode)
> +{
> +	if (remove_in_inode)
> +		landlock_inode_remove_map(*key, map);
> +	return htab_map_delete_elem(map, key);
> +}
> +
> +/* called from syscall */
> +int bpf_inode_fd_htab_map_delete_elem(struct bpf_map *map, int *key)
> +{
> +	struct inode *inode;
> +	int ret;
> +
> +	/* do not check inode access (similar to directory check) */
> +	inode = inode_from_fd(*key, false);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +	ret = bpf_inode_ptr_locked_htab_map_delete_elem(map, &inode, true);
> +	iput(inode);
> +	return ret;
> +}
> +
> +/* called from syscall */
> +int bpf_inode_fd_htab_map_update_elem(struct bpf_map *map, int *key, void *value,
> +		u64 map_flags)
> +{
> +	struct inode *inode;
> +	int ret;
> +
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +
> +	/* check inode access */
> +	inode = inode_from_fd(*key, true);
> +	if (IS_ERR(inode))
> +		return PTR_ERR(inode);
> +	ret = htab_map_update_elem(map, &inode, value, map_flags);
> +	if (!ret)
> +		ret = landlock_inode_add_map(inode, map);
> +	iput(inode);
> +	return ret;
> +}
> +
> +static void inode_htab_map_free(struct bpf_map *map)
> +{
> +	struct bpf_htab *htab = container_of(map, struct bpf_htab, map);
> +	struct hlist_nulls_node *n;
> +	struct hlist_nulls_head *head;
> +	struct htab_elem *l;
> +	int i;
> +
> +	for (i = 0; i < htab->n_buckets; i++) {
> +		head = select_bucket(htab, i);
> +		hlist_nulls_for_each_entry_safe(l, n, head, hash_node) {
> +			landlock_inode_remove_map(*((struct inode **)l->key), map);
> +		}
> +	}
> +	htab_map_free(map);
> +}

user space can delete the map.
that will trigger inode_htab_map_free() which will call
landlock_inode_remove_map().
which will simply itereate the list and delete from the list.

While in parallel inode can be destoyed and hook_inode_free_security()
will be called.
I think nothing that protects from this race.

> +
> +/*
> + * We need a dedicated helper to deal with inode maps because the key is a
> + * pointer to an opaque data, only provided by the kernel.  This really act
> + * like a (physical or cryptographic) key, which is why it is also not allowed
> + * to get the next key with map_get_next_key().

inode pointer is like cryptographic key? :)

> + */
> +BPF_CALL_2(bpf_inode_map_lookup_elem, struct bpf_map *, map, void *, key)
> +{
> +	WARN_ON_ONCE(!rcu_read_lock_held());
> +	return (unsigned long)htab_map_lookup_elem(map, &key);
> +}
> +
> +const struct bpf_func_proto bpf_inode_map_lookup_elem_proto = {
> +	.func		= bpf_inode_map_lookup_elem,
> +	.gpl_only	= false,
> +	.pkt_access	= true,

pkt_access ? :)

> +	.ret_type	= RET_PTR_TO_MAP_VALUE_OR_NULL,
> +	.arg1_type	= ARG_CONST_MAP_PTR,
> +	.arg2_type	= ARG_PTR_TO_INODE,
> +};
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index b2a8cb14f28e..e46441c42b68 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -801,6 +801,8 @@ static int map_lookup_elem(union bpf_attr *attr)
>  	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
>  		   map->map_type == BPF_MAP_TYPE_STACK) {
>  		err = map->ops->map_peek_elem(map, value);
> +	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
> +		err = bpf_inode_fd_htab_map_lookup_elem(map, key, value);
>  	} else {
>  		rcu_read_lock();
>  		if (map->ops->map_lookup_elem_sys_only)
> @@ -951,6 +953,10 @@ static int map_update_elem(union bpf_attr *attr)
>  	} else if (map->map_type == BPF_MAP_TYPE_QUEUE ||
>  		   map->map_type == BPF_MAP_TYPE_STACK) {
>  		err = map->ops->map_push_elem(map, value, attr->flags);
> +	} else if (map->map_type == BPF_MAP_TYPE_INODE) {
> +		rcu_read_lock();
> +		err = bpf_inode_fd_htab_map_update_elem(map, key, value, attr->flags);
> +		rcu_read_unlock();
>  	} else {
>  		rcu_read_lock();
>  		err = map->ops->map_update_elem(map, key, value, attr->flags);
> @@ -1006,7 +1012,10 @@ static int map_delete_elem(union bpf_attr *attr)
>  	preempt_disable();
>  	__this_cpu_inc(bpf_prog_active);
>  	rcu_read_lock();
> -	err = map->ops->map_delete_elem(map, key);
> +	if (map->map_type == BPF_MAP_TYPE_INODE)
> +		err = bpf_inode_fd_htab_map_delete_elem(map, key);
> +	else
> +		err = map->ops->map_delete_elem(map, key);
>  	rcu_read_unlock();
>  	__this_cpu_dec(bpf_prog_active);
>  	preempt_enable();
> @@ -1018,6 +1027,22 @@ static int map_delete_elem(union bpf_attr *attr)
>  	return err;
>  }
>  
> +int bpf_inode_ptr_unlocked_htab_map_delete_elem(struct bpf_map *map,
> +						struct inode **key, bool remove_in_inode)
> +{
> +	int err;
> +
> +	preempt_disable();
> +	__this_cpu_inc(bpf_prog_active);
> +	rcu_read_lock();
> +	err = bpf_inode_ptr_locked_htab_map_delete_elem(map, key, remove_in_inode);
> +	rcu_read_unlock();
> +	__this_cpu_dec(bpf_prog_active);
> +	preempt_enable();
> +	maybe_wait_bpf_programs(map);

if that function was actually doing synchronize_rcu() the consequences
would have been unpleasant. Fortunately it's a nop in this case.
Please read the code carefully before copy-paste.
Also what do you think the reason of bpf_prog_active above?
What is the reason of rcu_read_lock above?

I think the patch set needs to shrink at least in half to be reviewable.
The way you tie seccomp and lsm is probably the biggest obstacle
than any of the bugs above.
Can you drop seccomp ? and do it as normal lsm ?

