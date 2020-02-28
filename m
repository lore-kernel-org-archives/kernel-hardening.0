Return-Path: <SRS0=qMpl=4Q=lists.openwall.com=kernel-hardening-return-18007-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 415BDC3F2D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 12:45:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 649AF246A3
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 12:45:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="prezLH9X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 649AF246A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18007-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15658 invoked by uid 550); 28 Feb 2020 12:45:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15624 invoked from network); 28 Feb 2020 12:45:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8/UqvYVXzGtEHBHG3XZtTd7eLo2Dd8AJKY596FBc5Ug=;
        b=prezLH9Xbn8f+sjYaMIfUr2Gvgx+x2oIGkguJXqQPiJMUIqyK7FDnyNzKe4tc3nrkk
         sjIKGN+v0ETXEPevWARyIzET0DOzN+STX3ZeNw1RhJVQ5iC3cBMVtgacJa1Fn3moPU8a
         K+pNoHmUuM7XkSN+dRAqfM5SkTq4Ng9q8vTzmThl9N4e4VLEY5eONftZRrTySQ+sqCSk
         da+TYqs0ySTiS/BrnCPps/0E6el1kX3/jMOAKUYURP4mBTXN/dZbV2QFyGxK9bdp5ew2
         ZF1lDjOp9rUpBjDPvmTi/PZ1+zf9GaI2nWsKlk90mjE3pNzSGMbV6ABZ2TE8ihQioK2n
         j6kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8/UqvYVXzGtEHBHG3XZtTd7eLo2Dd8AJKY596FBc5Ug=;
        b=UlaWI7ua5lC+6dlJCXQiGWHwgzD+4SHsKWkzWItvY3I7D88WxRZyFvUuO6m9wnppwO
         R+HmreO6huNZ1bnasVhf1TUsZoSySAZQQ+/J8OcidbAUm+TXyx97BszYzRq7w1sIfb/J
         T+fS17ifFSsIwdsWTJrNP+eg7BslTI3z3qVi8Sj9JHiflRLvjJTpaCACy4PSSbf1YTd/
         eq+UMvIV/YNHT8ltCjEF8nmzb5Q1PflZzXuhkcqgT3GXiMgSA0sJBM5PTQIL43vXitUm
         bY03Anc8403zUdd8ETSLQDScAvFhBz0KlgkRdsaGRqImQsqCh83E59JNQNr3lB5tQf8T
         vm/A==
X-Gm-Message-State: APjAAAWvamwUpWlMwYp96tYo0N2VE1OvYM6PIDS4CVra+7fgw3/xiWz3
	kWdU0+FOtQJBe6dC3D+pmQVNfmwQj8iD5ReKRk9Ggg==
X-Google-Smtp-Source: APXvYqxhZpSDDOImeSVjwEmthLdKce91XpRL+jBEzDXas9COyEuY6T3hZTtVGivhzHuIxaQWhhpySo2Zz3uSt1l8Yss=
X-Received: by 2002:a17:902:8492:: with SMTP id c18mr4058531plo.147.1582893919646;
 Fri, 28 Feb 2020 04:45:19 -0800 (PST)
MIME-Version: 1.0
References: <20200227193516.32566-1-keescook@chromium.org> <20200227193516.32566-7-keescook@chromium.org>
In-Reply-To: <20200227193516.32566-7-keescook@chromium.org>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Fri, 28 Feb 2020 13:45:08 +0100
Message-ID: <CAAeHK+xhFJxUeY4BN52Rd6Q_DH582VhQ2pbZZcrDYrnaUHQufQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] ubsan: Include bug type in report header
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Ryabinin <aryabinin@virtuozzo.com>, Elena Petrova <lenaptr@google.com>, 
	Alexander Potapenko <glider@google.com>, Dan Carpenter <dan.carpenter@oracle.com>, 
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, Arnd Bergmann <arnd@arndb.de>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, kasan-dev <kasan-dev@googlegroups.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	kernel-hardening@lists.openwall.com, syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 27, 2020 at 8:35 PM Kees Cook <keescook@chromium.org> wrote:
>
> When syzbot tries to figure out how to deduplicate bug reports, it
> prefers seeing a hint about a specific bug type (we can do better than
> just "UBSAN"). This lifts the handler reason into the UBSAN report line
> that includes the file path that tripped a check. Unfortunately, UBSAN
> does not provide function names.
>
> Suggested-by: Dmitry Vyukov <dvyukov@google.com>
> Link: https://lore.kernel.org/lkml/CACT4Y+bsLJ-wFx_TaXqax3JByUOWB3uk787LsyMVcfW6JzzGvg@mail.gmail.com
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  lib/ubsan.c | 36 +++++++++++++++---------------------
>  1 file changed, 15 insertions(+), 21 deletions(-)
>
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index 429663eef6a7..f8c0ccf35f29 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -45,13 +45,6 @@ static bool was_reported(struct source_location *location)
>         return test_and_set_bit(REPORTED_BIT, &location->reported);
>  }
>
> -static void print_source_location(const char *prefix,
> -                               struct source_location *loc)
> -{
> -       pr_err("%s %s:%d:%d\n", prefix, loc->file_name,
> -               loc->line & LINE_MASK, loc->column & COLUMN_MASK);
> -}
> -
>  static bool suppress_report(struct source_location *loc)
>  {
>         return current->in_ubsan || was_reported(loc);
> @@ -140,13 +133,14 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
>         }
>  }
>
> -static void ubsan_prologue(struct source_location *location)
> +static void ubsan_prologue(struct source_location *loc, const char *reason)
>  {
>         current->in_ubsan++;
>
>         pr_err("========================================"
>                 "========================================\n");
> -       print_source_location("UBSAN: Undefined behaviour in", location);
> +       pr_err("UBSAN: %s in %s:%d:%d\n", reason, loc->file_name,
> +               loc->line & LINE_MASK, loc->column & COLUMN_MASK);
>  }
>
>  static void ubsan_epilogue(void)
> @@ -180,12 +174,12 @@ static void handle_overflow(struct overflow_data *data, void *lhs,
>         if (suppress_report(&data->location))
>                 return;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, type_is_signed(type) ?
> +                       "signed-integer-overflow" :
> +                       "unsigned-integer-overflow");
>
>         val_to_string(lhs_val_str, sizeof(lhs_val_str), type, lhs);
>         val_to_string(rhs_val_str, sizeof(rhs_val_str), type, rhs);
> -       pr_err("%s integer overflow:\n",
> -               type_is_signed(type) ? "signed" : "unsigned");
>         pr_err("%s %c %s cannot be represented in type %s\n",
>                 lhs_val_str,
>                 op,
> @@ -225,7 +219,7 @@ void __ubsan_handle_negate_overflow(struct overflow_data *data,
>         if (suppress_report(&data->location))
>                 return;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "negation-overflow");
>
>         val_to_string(old_val_str, sizeof(old_val_str), data->type, old_val);
>
> @@ -245,7 +239,7 @@ void __ubsan_handle_divrem_overflow(struct overflow_data *data,
>         if (suppress_report(&data->location))
>                 return;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "division-overflow");
>
>         val_to_string(rhs_val_str, sizeof(rhs_val_str), data->type, rhs);
>
> @@ -264,7 +258,7 @@ static void handle_null_ptr_deref(struct type_mismatch_data_common *data)
>         if (suppress_report(data->location))
>                 return;
>
> -       ubsan_prologue(data->location);
> +       ubsan_prologue(data->location, "null-ptr-deref");
>
>         pr_err("%s null pointer of type %s\n",
>                 type_check_kinds[data->type_check_kind],
> @@ -279,7 +273,7 @@ static void handle_misaligned_access(struct type_mismatch_data_common *data,
>         if (suppress_report(data->location))
>                 return;
>
> -       ubsan_prologue(data->location);
> +       ubsan_prologue(data->location, "misaligned-access");
>
>         pr_err("%s misaligned address %p for type %s\n",
>                 type_check_kinds[data->type_check_kind],
> @@ -295,7 +289,7 @@ static void handle_object_size_mismatch(struct type_mismatch_data_common *data,
>         if (suppress_report(data->location))
>                 return;
>
> -       ubsan_prologue(data->location);
> +       ubsan_prologue(data->location, "object-size-mismatch");
>         pr_err("%s address %p with insufficient space\n",
>                 type_check_kinds[data->type_check_kind],
>                 (void *) ptr);
> @@ -354,7 +348,7 @@ void __ubsan_handle_out_of_bounds(struct out_of_bounds_data *data, void *index)
>         if (suppress_report(&data->location))
>                 return;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "array-index-out-of-bounds");
>
>         val_to_string(index_str, sizeof(index_str), data->index_type, index);
>         pr_err("index %s is out of range for type %s\n", index_str,
> @@ -375,7 +369,7 @@ void __ubsan_handle_shift_out_of_bounds(struct shift_out_of_bounds_data *data,
>         if (suppress_report(&data->location))
>                 goto out;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "shift-out-of-bounds");
>
>         val_to_string(rhs_str, sizeof(rhs_str), rhs_type, rhs);
>         val_to_string(lhs_str, sizeof(lhs_str), lhs_type, lhs);
> @@ -407,7 +401,7 @@ EXPORT_SYMBOL(__ubsan_handle_shift_out_of_bounds);
>
>  void __ubsan_handle_builtin_unreachable(struct unreachable_data *data)
>  {
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "unreachable");
>         pr_err("calling __builtin_unreachable()\n");
>         ubsan_epilogue();
>         panic("can't return from __builtin_unreachable()");
> @@ -422,7 +416,7 @@ void __ubsan_handle_load_invalid_value(struct invalid_value_data *data,
>         if (suppress_report(&data->location))
>                 return;
>
> -       ubsan_prologue(&data->location);
> +       ubsan_prologue(&data->location, "invalid-load");
>
>         val_to_string(val_str, sizeof(val_str), data->type, val);
>
> --
> 2.20.1
>
> --
> You received this message because you are subscribed to the Google Groups "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/kasan-dev/20200227193516.32566-7-keescook%40chromium.org.

Acked-by: Andrey Konovalov <andreyknvl@google.com>

Thanks!
