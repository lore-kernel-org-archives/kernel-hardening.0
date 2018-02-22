MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180222231442.29507-2-labbott@redhat.com>
References: <20180222231442.29507-1-labbott@redhat.com> <20180222231442.29507-2-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 22 Feb 2018 15:40:43 -0800
Message-ID: <CAGXu5j+eXU98vmERF+_7gfcNbkztav+JP3SJRexa=MLtyhb70Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: Update cgraph_create_edge for gcc-8
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 22, 2018 at 3:14 PM, Laura Abbott <labbott@redhat.com> wrote:
>
> gcc-8 changed the API for cgraph_create_edge. Update accordingly.
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> ---
>  scripts/gcc-plugins/gcc-common.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
> index f46750053377..42c55c29157f 100644
> --- a/scripts/gcc-plugins/gcc-common.h
> +++ b/scripts/gcc-plugins/gcc-common.h
> @@ -723,8 +723,14 @@ static inline const char *get_decl_section_name(const_tree decl)
>  #define varpool_get_node(decl) varpool_node::get(decl)
>  #define dump_varpool_node(file, node) (node)->dump(file)
>
> +#if BUILDING_GCC_VERSION >= 8000
> +#define cgraph_create_edge(caller, callee, call_stmt, count, nest) \
> +       (caller)->create_edge((callee), (call_stmt), (count))
> +#else
>  #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
>         (caller)->create_edge((callee), (call_stmt), (count), (freq))
> +
> +#endif

Since gcc 8 "throws away" the freq argument, could this just be
updated to do the same? i.e., leave "freq" as an argument, and just
don't use it? That way the plugin caller doesn't need to be updated.

+#if BUILDING_GCC_VERSION >= 8000
+#define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
+       (caller)->create_edge((callee), (call_stmt), (count))
+#else
 #define cgraph_create_edge(caller, callee, call_stmt, count, freq, nest) \
        (caller)->create_edge((callee), (call_stmt), (count), (freq))
+#endif


-Kees

-- 
Kees Cook
Pixel Security
