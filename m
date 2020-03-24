Return-Path: <SRS0=Q17D=5J=lists.openwall.com=kernel-hardening-return-18192-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC3BC43331
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 18:18:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5CE6820714
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Mar 2020 18:18:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AlJXW4lv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5CE6820714
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18192-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1362 invoked by uid 550); 24 Mar 2020 18:18:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7652 invoked from network); 24 Mar 2020 16:23:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bmrR+6P0T9fHgGZsbiFrTmDeS2rx+GhVlz+ne+F87k4=;
        b=AlJXW4lvwKjh98zDcnGMjWN/G2d4az2n2nwlYoLI/ymnLJqGIf8HJ+1yOfdljW7fse
         OPSIDDmHoTllb9HeQn3MSCu5uriWphlynSyeziolFUYakiZnaKJQ2CCpQJFTGinZ0IVB
         wStcyt7P6QwbH2r+sXzrkqGUTCL7h8/u2NjJmOhyWV/C3KcgUM0a6kOuoSd5g+Gm/Pfj
         zdNIgJK9bYporXWUgmqvNaBaMPRbWSse3BVWUQeJL71cYCO5f1zvILnPul09KFSTLDdB
         1IM03y2ZlZSMhgJ0r9b7u3dwluYURW/Oazn13up86FjFSRy/+hr7IaInTJtcBs9eGwTo
         Aisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bmrR+6P0T9fHgGZsbiFrTmDeS2rx+GhVlz+ne+F87k4=;
        b=Bt+DjpYIcTT8CmZOMvq0FqHUHUmc5HGM1aXF/lAhUS7tlLz5owYZH3AjMa50NTMozq
         DTCc+RyB0+7n8J4qKkDTW3xhJEzTke9M8wwq3IU1J+Hwd9LrpzXoYcbkWnvs89Afv37k
         YJpZ02qMlytxWaa8Hg/IUuc6+G0LMP4XWyR720/e3srCxdCwK+/+Cp4nqMBe+z1cbcxc
         cVwMiObF13MUhyZ0QQHSCGydbSU2MBcOHOw0jveMFH/TR9hsMxISMpkfDtlvDvhvT+z+
         6rqGcIKDwWiPsCDR1x6kJXvF0zOuqOfu5WClZYqJiV72/1th8ecGGuMmy6ai4O5koZEd
         BuCA==
X-Gm-Message-State: ANhLgQ2DWb4wHZ9pCSEmmXML74GtuMsVFlaGB9r+s4iq2FIWeIL6ck15
	H1YrBF8ZuYHeIpnIflb3td3jRc0y4Rb9hg+57bWjbA==
X-Google-Smtp-Source: ADFU+vtH3krm4BYvOxY9/ud4Giu0K3lKA6cdG0PrNUvKtwz4VLFIMPL6zHs6cQHDvnyQsZfZzvnQ8hd8j/qfBCWPEgs=
X-Received: by 2002:aca:3089:: with SMTP id w131mr4090746oiw.121.1585067023352;
 Tue, 24 Mar 2020 09:23:43 -0700 (PDT)
MIME-Version: 1.0
References: <20200324153643.15527-1-will@kernel.org> <20200324153643.15527-4-will@kernel.org>
In-Reply-To: <20200324153643.15527-4-will@kernel.org>
From: Marco Elver <elver@google.com>
Date: Tue, 24 Mar 2020 17:23:30 +0100
Message-ID: <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
To: Will Deacon <will@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
	Maddie Stone <maddiestone@google.com>, "Paul E . McKenney" <paulmck@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com, 
	kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 24 Mar 2020 at 16:37, Will Deacon <will@kernel.org> wrote:
>
> Some list predicates can be used locklessly even with the non-RCU list
> implementations, since they effectively boil down to a test against
> NULL. For example, checking whether or not a list is empty is safe even
> in the presence of a concurrent, tearing write to the list head pointer.
> Similarly, checking whether or not an hlist node has been hashed is safe
> as well.
>
> Annotate these lockless list predicates with data_race() and READ_ONCE()
> so that KCSAN and the compiler are aware of what's going on. The writer
> side can then avoid having to use WRITE_ONCE() in the non-RCU
> implementation.
>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Marco Elver <elver@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  include/linux/list.h       | 10 +++++-----
>  include/linux/list_bl.h    |  5 +++--
>  include/linux/list_nulls.h |  6 +++---
>  include/linux/llist.h      |  2 +-
>  4 files changed, 12 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
>   */
>  static inline int list_empty(const struct list_head *head)
>  {
> -       return READ_ONCE(head->next) == head;
> +       return data_race(READ_ONCE(head->next) == head);

Double-marking should never be necessary, at least if you want to make
KCSAN happy. From what I gather there is an unmarked write somewhere,
correct? In that case, KCSAN will still complain because if it sees a
race between this read and the other write, then at least one is still
plain (the write).

Then, my suggestion would be to mark the write with data_race() and
just leave this as a READ_ONCE(). Having a data_race() somewhere only
makes KCSAN stop reporting the race if the paired access is also
marked (be it with data_race() or _ONCE, etc.).

Alternatively, if marking the write is impossible, you can surround
the access with kcsan_disable_current()/kcsan_enable_current(). Or, as
a last resort, just leaving as-is is fine too, because KCSAN's default
config (still) has KCSAN_ASSUME_PLAIN_WRITES_ATOMIC selected.

Thanks,
-- Marco

>  }
>
>  /**
> @@ -524,7 +524,7 @@ static inline void list_splice_tail_init(struct list_head *list,
>   */
>  #define list_first_entry_or_null(ptr, type, member) ({ \
>         struct list_head *head__ = (ptr); \
> -       struct list_head *pos__ = READ_ONCE(head__->next); \
> +       struct list_head *pos__ = data_race(READ_ONCE(head__->next)); \
>         pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
>  })
>
> @@ -772,13 +772,13 @@ static inline void INIT_HLIST_NODE(struct hlist_node *h)
>   * hlist_unhashed - Has node been removed from list and reinitialized?
>   * @h: Node to be checked
>   *
> - * Not that not all removal functions will leave a node in unhashed
> + * Note that not all removal functions will leave a node in unhashed
>   * state.  For example, hlist_nulls_del_init_rcu() does leave the
>   * node in unhashed state, but hlist_nulls_del() does not.
>   */
>  static inline int hlist_unhashed(const struct hlist_node *h)
>  {
> -       return !READ_ONCE(h->pprev);
> +       return data_race(!READ_ONCE(h->pprev));
>  }
>
>  /**
> @@ -787,7 +787,7 @@ static inline int hlist_unhashed(const struct hlist_node *h)
>   */
>  static inline int hlist_empty(const struct hlist_head *h)
>  {
> -       return !READ_ONCE(h->first);
> +       return data_race(!READ_ONCE(h->first));
>  }
>
>  static inline void __hlist_del(struct hlist_node *n)
> diff --git a/include/linux/list_bl.h b/include/linux/list_bl.h
> index ae1b541446c9..1804fdb84dda 100644
> --- a/include/linux/list_bl.h
> +++ b/include/linux/list_bl.h
> @@ -51,7 +51,7 @@ static inline void INIT_HLIST_BL_NODE(struct hlist_bl_node *h)
>
>  static inline bool  hlist_bl_unhashed(const struct hlist_bl_node *h)
>  {
> -       return !h->pprev;
> +       return data_race(!READ_ONCE(h->pprev));
>  }
>
>  static inline struct hlist_bl_node *hlist_bl_first(struct hlist_bl_head *h)
> @@ -71,7 +71,8 @@ static inline void hlist_bl_set_first(struct hlist_bl_head *h,
>
>  static inline bool hlist_bl_empty(const struct hlist_bl_head *h)
>  {
> -       return !((unsigned long)READ_ONCE(h->first) & ~LIST_BL_LOCKMASK);
> +       unsigned long first = data_race((unsigned long)READ_ONCE(h->first));
> +       return !(first & ~LIST_BL_LOCKMASK);
>  }
>
>  static inline void hlist_bl_add_head(struct hlist_bl_node *n,
> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> index 3a9ff01e9a11..fa51a801bf32 100644
> --- a/include/linux/list_nulls.h
> +++ b/include/linux/list_nulls.h
> @@ -60,18 +60,18 @@ static inline unsigned long get_nulls_value(const struct hlist_nulls_node *ptr)
>   * hlist_nulls_unhashed - Has node been removed and reinitialized?
>   * @h: Node to be checked
>   *
> - * Not that not all removal functions will leave a node in unhashed state.
> + * Note that not all removal functions will leave a node in unhashed state.
>   * For example, hlist_del_init_rcu() leaves the node in unhashed state,
>   * but hlist_nulls_del() does not.
>   */
>  static inline int hlist_nulls_unhashed(const struct hlist_nulls_node *h)
>  {
> -       return !READ_ONCE(h->pprev);
> +       return data_race(!READ_ONCE(h->pprev));
>  }
>
>  static inline int hlist_nulls_empty(const struct hlist_nulls_head *h)
>  {
> -       return is_a_nulls(READ_ONCE(h->first));
> +       return data_race(is_a_nulls(READ_ONCE(h->first)));
>  }
>
>  static inline void hlist_nulls_add_head(struct hlist_nulls_node *n,
> diff --git a/include/linux/llist.h b/include/linux/llist.h
> index 2e9c7215882b..c7f042b73899 100644
> --- a/include/linux/llist.h
> +++ b/include/linux/llist.h
> @@ -186,7 +186,7 @@ static inline void init_llist_head(struct llist_head *list)
>   */
>  static inline bool llist_empty(const struct llist_head *head)
>  {
> -       return READ_ONCE(head->first) == NULL;
> +       return data_race(READ_ONCE(head->first) == NULL);
>  }
>
>  static inline struct llist_node *llist_next(struct llist_node *node)
> --
> 2.20.1
>
