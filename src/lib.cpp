#include "this_aip_load.h"
#include "seeta_aip_package_v2.h"

namespace {
    /**
     * This class init this AIP header, change it to own module
     */
    class ThisAIPHeader : public SeetaAIP {
    public:
        using self = ThisAIPHeader;
        using supper = SeetaAIP;

        ThisAIPHeader() : supper({0}) {
            this->aip_version = SEETA_AIP_VERSION;
            this->module = THIS_AIP_MODULE;
            this->description = "This is " THIS_AIP_MODULE;
            this->mID = THIS_AIP_MODULE;
            this->sID = THIS_AIP_MODULE;
            this->version = "1.0.0";
            static const char *support[] = {"cpu", nullptr};
            this->support = support;
        }
    } this_aip_header;  ///< Do NOT change this object nname and class, because it used by auto generated codes.

    /**
     * Do NOT change this class name, because it used by auto generated codes.
     */
    class ThisPackage : public seeta::aip::PackageV2 {
    public:
        using self = ThisPackage;
        using supper = seeta::aip::PackageV2;

        ThisPackage() {
            // Use `bind_property` to bind property for get and set
            // Use `bind_error` to bind error code and error message
            // Use `bind_tag` to bind tag index and name
            // If each method result are same, alloc memory at here to avoid temp object realloc
        }

        /**
         * Create new AIP with give parameter
         * @param device Computing device, like cpu or gpu:1.
         * @param models Required models, check number if needed.
         * @param args Object to tell how create this AIP, often be empty.
         */
        void create(
                const SeetaAIPDevice &device,
                const std::vector<std::string> &models,
                const std::vector<SeetaAIPObject> &args) final {
        }

        /**
         * Free this AIP.
         * After this, no AIP's APIs should be called.
         */
        void free() final {
        }

        /**
         * Forward computing.
         * @param method_id Used method id, telling which method wanted.
         * @param images Input images.
         * @param objects Input Objects.
         * @note Output object and images must be set into `this->result`.
         */
        void forward(
                uint32_t method_id,
                const std::vector<SeetaAIPImageData> &images,
                const std::vector<SeetaAIPObject> &objects) final {
        }

        /**
         * Reset this object for next serial forward.
         * Only used in stream mode.
         * If there is nothing to reset, the no actions.
         */
        void reset() final {
        }
    };

    /**
     * This class use for DLL load and unload action, to create and recycle global vars.
     */
    class ThisAIP {
    public:
        using self = ThisAIP;

        /**
         * When this library loaded
         */
        ThisAIP() {
        }

        /**
         * Before this library freed
         */
        ~ThisAIP() {
        }

    } this_aip;
}

/* = Do not Edit following code, ONLY if you know HOW it works. = */

SEETA_AIP_API int32_t this_aip_load(struct SeetaAIP *aip, uint32_t size) {
    // Check parameter OK
    if (!aip) return SEETA_AIP_LOAD_UNHANDLED_INTERNAL_ERROR;
    // Check parameter legal
    CHECK_AIP_SIZE(aip, size)
    // Set header
    *aip = this_aip_header;
    // Set methods
    seeta::aip::setup_aip_entry<ThisPackage>(*aip);
    // Package load succeed.
    return SEETA_AIP_LOAD_SUCCEED;
}

SEETA_AIP_API int32_t seeta_aip_load(struct SeetaAIP *aip, uint32_t size) {
    return this_aip_load(aip, size);
}