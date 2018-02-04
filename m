From: valdis.kletnieks@vt.edu
Subject: [PATCH 2/2] GCC release 8 support for gcc-plugins
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sun, 04 Feb 2018 12:34:38 -0500
Message-ID: <123377.1517765678@turing-police.cc.vt.edu>
To: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

For reasons totally beyond my understanding, gcc 8 changed the
order of two structure member, which leads to an error:

  HOSTCXX -fPIC scripts/gcc-plugins/latent_entropy_plugin.o
scripts/gcc-plugins/latent_entropy_plugin.c:269:1: error: designator order for field 'attribute_spec::affects_type_identity' does not match declaration order in 'attribute_spec'
 };
 ^
make[1]: *** [scripts/Makefile.host:141: scripts/gcc-plugins/latent_entropy_plugin.o] Error 1

Maybe we'll get lucky and they'll undo that change before official release, so all
this ad-crock #ifdef-ery won't be needed.  Do we know any gcc experts to ask?

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

--- diff --git a/scripts/gcc-plugins/latent_entropy_plugin.c b/scripts/gcc-plugins/latent_entropy_plugin.c
index 65264960910d..15a6df3592c5 100644
--- a/scripts/gcc-plugins/latent_entropy_plugin.c
+++ b/scripts/gcc-plugins/latent_entropy_plugin.c
@@ -262,10 +262,17 @@ static struct attribute_spec latent_entropy_attr = {
 	.decl_required			= true,
 	.type_required			= false,
 	.function_type_required		= false,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
 	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity		= false
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static void register_attributes(void *event_data __unused, void *data __unused)
diff --git a/scripts/gcc-plugins/structleak_plugin.c b/scripts/gcc-plugins/structleak_plugin.c
index 3f8dd4868178..f700bc059050 100644
--- a/scripts/gcc-plugins/structleak_plugin.c
+++ b/scripts/gcc-plugins/structleak_plugin.c
@@ -64,10 +64,17 @@ static struct attribute_spec user_attr = {
 	.decl_required		= false,
 	.type_required		= false,
 	.function_type_required	= false,
-	.handler		= handle_user_attribute,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
+	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity	= true
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static void register_attributes(void *event_data, void *data)
diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index 0073af326449..1dafa102a907 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -589,10 +589,17 @@ static struct attribute_spec randomize_layout_attr = {
 	// need type declaration
 	.type_required	= true,
 	.function_type_required = false,
-	.handler		= handle_randomize_layout_attr,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
+	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity  = true
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static struct attribute_spec no_randomize_layout_attr = {
@@ -604,10 +611,17 @@ static struct attribute_spec no_randomize_layout_attr = {
 	// need type declaration
 	.type_required	= true,
 	.function_type_required = false,
-	.handler		= handle_randomize_layout_attr,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
+	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity  = true
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static struct attribute_spec randomize_considered_attr = {
@@ -619,10 +633,17 @@ static struct attribute_spec randomize_considered_attr = {
 	// need type declaration
 	.type_required	= true,
 	.function_type_required = false,
-	.handler		= handle_randomize_considered_attr,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
+	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity  = false
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static struct attribute_spec randomize_performed_attr = {
@@ -634,10 +655,17 @@ static struct attribute_spec randomize_performed_attr = {
 	// need type declaration
 	.type_required	= true,
 	.function_type_required = false,
-	.handler		= handle_randomize_performed_attr,
+#if BUILDING_GCC_VERSION >= 8000
+	.affects_type_identity		= false,
+	.handler			= handle_latent_entropy_attribute,
+#else
 #if BUILDING_GCC_VERSION >= 4007
-	.affects_type_identity  = false
-#endif
+	.handler			= handle_latent_entropy_attribute,
+	.affects_type_identity		= false,
+#else
+	.handler			= handle_latent_entropy_attribute,
+#endif /* >= 4007 */
+#endif /* >= 8000 */
 };
 
 static void register_attributes(void *event_data, void *data)
