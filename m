From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:29 -0700
Message-Id: <1491513513-84351-15-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 14/18] randstruct: Disable randomization of ACPICA structs
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Since the ACPICA source is maintained externally to the kernel, we can
neither switch it to designated initializers nor mark it
__no_randomize_layout. Until ACPICA-upstream changes land to handle the
designated initialization, explicitly skip it in the plugin.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index a2d7e933c33f..cbde695e392a 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -329,6 +329,10 @@ static int relayout_struct(tree type)
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
