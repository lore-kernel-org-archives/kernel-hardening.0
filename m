MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <123377.1517765678@turing-police.cc.vt.edu>
References: <123377.1517765678@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 6 Feb 2018 12:07:31 +1100
Message-ID: <CAGXu5jJYwtUwYWh9VfuZ7hydScoBaT3gWbjcN=TpnZsywYO3Ng@mail.gmail.com>
Subject: Re: [PATCH 2/2] GCC release 8 support for gcc-plugins
Content-Type: text/plain; charset="UTF-8"
To: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 5, 2018 at 4:34 AM,  <valdis.kletnieks@vt.edu> wrote:
> For reasons totally beyond my understanding, gcc 8 changed the
> order of two structure member, which leads to an error:
>
>   HOSTCXX -fPIC scripts/gcc-plugins/latent_entropy_plugin.o
> scripts/gcc-plugins/latent_entropy_plugin.c:269:1: error: designator order for field 'attribute_spec::affects_type_identity' does not match declaration order in 'attribute_spec'
>  };
>  ^

FWIW, my gcc 8 snapshot reports:

scripts/gcc-plugins/latent_entropy_plugin.c:269:1: sorry,
unimplemented: non-trivial designated initializers not supported
 };
 ^

But yeah, it seems that initializer _order_ matters here. Uuuugh.

I think instead of static initializers, we can just move this into the
register function, then order won't matter again. e.g.:


diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c
b/scripts/gcc-plugins/latent_entropy_plugin.c
index 65264960910d..6836b8cd9fc4 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -255,21 +255,21 @@ static tree handle_latent_entropy_attribute(tree
*node, tree name,
        return NULL_TREE;
 }

-static struct attribute_spec latent_entropy_attr = {
-       .name                           = "latent_entropy",
-       .min_length                     = 0,
-       .max_length                     = 0,
-       .decl_required                  = true,
-       .type_required                  = false,
-       .function_type_required         = false,
-       .handler                        = handle_latent_entropy_attribute,
-#if BUILDING_GCC_VERSION >= 4007
-       .affects_type_identity          = false
-#endif
-};
+static struct attribute_spec latent_entropy_attr;

 static void register_attributes(void *event_data __unused, void *data __unused)
 {
+       latent_entropy_attr.name                        = "latent_entropy";
+       latent_entropy_attr.min_length                  = 0;
+       latent_entropy_attr.max_length                  = 0;
+       latent_entropy_attr.decl_required               = true;
+       latent_entropy_attr.type_required               = false;
+       latent_entropy_attr.function_type_required      = false;
+       latent_entropy_attr.handler     = handle_latent_entropy_attribute;
+#if BUILDING_GCC_VERSION >= 4007
+       latent_entropy_attr.affects_type_identity       = false;
+#endif
+
        register_attribute(&latent_entropy_attr);
 }

(pardon whitespace damage...)

-Kees

-- 
Kees Cook
Pixel Security
