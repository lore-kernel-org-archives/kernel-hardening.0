From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:15 -0700
Message-Id: <1495829844-69341-12-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 11/20] randstruct: Disable randomization of ACPICA structs
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Since the ACPICA source is maintained externally to the kernel, we can
neither switch it to designated initializers nor mark it
__no_randomize_layout. Until ACPICA-upstream changes[1] land to handle the
designated initialization, explicitly skip it in the plugin.

[1] https://github.com/acpica/acpica/pull/248

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index f777ead58ba8..e6e02a40d522 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -346,6 +346,10 @@ static int relayout_struct(tree type)
 	    !strcmp((const char *)ORIG_TYPE_NAME(type), "RAWPCIFACTORY"))
 		return 0;
 
+	/* Skip ACPICA structs until refreshed with designated_init. */
+	if (!strcmp((const char *)ORIG_TYPE_NAME(type), "acpi_sleep_functions"))
+		return 0;
+
 	/* throw out any structs in uapi */
 	xloc = expand_location(DECL_SOURCE_LOCATION(TYPE_FIELDS(type)));
 
-- 
2.7.4
