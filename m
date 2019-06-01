From: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [RFC 3/6] driver/core: Convert to use built-in RCU list checking
Date: Sat,  1 Jun 2019 18:27:35 -0400
Message-Id: <20190601222738.6856-4-joel@joelfernandes.org>
In-Reply-To: <20190601222738.6856-1-joel@joelfernandes.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: "Joel Fernandes (Google)" <joel@joelfernandes.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller" <davem@davemloft.net>, edumazet@google.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org, kernel-hardening@lists.openwall.com, Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org, linux-pm@vger.kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com, netdev@vger.kernel.org, oleg@redhat.com, "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>, peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE 32-BIT AND 64-BIT" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

list_for_each_entry_rcu has built-in RCU and lock checking. Make use of
it in driver core.

Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
 drivers/base/base.h          |  1 +
 drivers/base/core.c          | 10 ++++++++++
 drivers/base/power/runtime.c | 15 ++++++++++-----
 3 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/base/base.h b/drivers/base/base.h
index b405436ee28e..0d32544b6f91 100644
--- a/drivers/base/base.h
+++ b/drivers/base/base.h
@@ -165,6 +165,7 @@ static inline int devtmpfs_init(void) { return 0; }
 /* Device links support */
 extern int device_links_read_lock(void);
 extern void device_links_read_unlock(int idx);
+extern int device_links_read_lock_held(void);
 extern int device_links_check_suppliers(struct device *dev);
 extern void device_links_driver_bound(struct device *dev);
 extern void device_links_driver_cleanup(struct device *dev);
diff --git a/drivers/base/core.c b/drivers/base/core.c
index fd7511e04e62..6c5ca9685647 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -68,6 +68,11 @@ void device_links_read_unlock(int idx)
 {
 	srcu_read_unlock(&device_links_srcu, idx);
 }
+
+int device_links_read_lock_held(void)
+{
+	return srcu_read_lock_held(&device_links_srcu);
+}
 #else /* !CONFIG_SRCU */
 static DECLARE_RWSEM(device_links_lock);
 
@@ -91,6 +96,11 @@ void device_links_read_unlock(int not_used)
 {
 	up_read(&device_links_lock);
 }
+
+int device_links_read_lock_held(void)
+{
+	return lock_is_held(&device_links_lock);
+}
 #endif /* !CONFIG_SRCU */
 
 /**
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index 952a1e7057c7..7a10e8379a70 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -287,7 +287,8 @@ static int rpm_get_suppliers(struct device *dev)
 {
 	struct device_link *link;
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
+				device_links_read_lock_held()) {
 		int retval;
 
 		if (!(link->flags & DL_FLAG_PM_RUNTIME) ||
@@ -309,7 +310,8 @@ static void rpm_put_suppliers(struct device *dev)
 {
 	struct device_link *link;
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node) {
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
+				device_links_read_lock_held()) {
 		if (READ_ONCE(link->status) == DL_STATE_SUPPLIER_UNBIND)
 			continue;
 
@@ -1640,7 +1642,8 @@ void pm_runtime_clean_up_links(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu(link, &dev->links.consumers, s_node) {
+	list_for_each_entry_rcu(link, &dev->links.consumers, s_node,
+				device_links_read_lock_held()) {
 		if (link->flags & DL_FLAG_STATELESS)
 			continue;
 
@@ -1662,7 +1665,8 @@ void pm_runtime_get_suppliers(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
+				device_links_read_lock_held())
 		if (link->flags & DL_FLAG_PM_RUNTIME) {
 			link->supplier_preactivated = true;
 			refcount_inc(&link->rpm_active);
@@ -1683,7 +1687,8 @@ void pm_runtime_put_suppliers(struct device *dev)
 
 	idx = device_links_read_lock();
 
-	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node)
+	list_for_each_entry_rcu(link, &dev->links.suppliers, c_node,
+				device_links_read_lock_held())
 		if (link->supplier_preactivated) {
 			link->supplier_preactivated = false;
 			if (refcount_dec_not_one(&link->rpm_active))
-- 
2.22.0.rc1.311.g5d7573a151-goog
